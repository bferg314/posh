using System;
using System.DirectoryServices.AccountManagement;
using System.DirectoryServices.ActiveDirectory;
using System.Linq;

class Program
{
    static void Main()
    {
        string groupName = "YourGroupName";
        string domainController = GetCurrentDomainController();
        GetUsersInGroup(groupName, domainController);
    }

    static string GetCurrentDomainController()
    {
        using (var domainContext = new DirectoryContext(DirectoryContextType.Domain))
        {
            using (var domain = Domain.GetDomain(domainContext))
            {
                var domainController = domain.FindDomainController();
                return domainController.Name;
            }
        }
    }

    static void GetUsersInGroup(string groupName, string domainController)
    {
        using (var context = new PrincipalContext(ContextType.Domain, domainController, "ldaps://" + domainController + ":636", ContextOptions.SimpleBind))
        {
            using (var group = GroupPrincipal.FindByIdentity(context, groupName))
            {
                if (group != null)
                {
                    var users = group.GetMembers(true)
                                     .OfType<UserPrincipal>()
                                     .Select(u => u.SamAccountName);

                    foreach (var user in users)
                    {
                        Console.WriteLine(user);
                    }
                }
                else
                {
                    Console.WriteLine("Group not found.");
                }
            }
        }
    }
}
