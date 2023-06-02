using System;
using System.DirectoryServices.AccountManagement;
using System.Linq;

class Program
{
    static void Main()
    {
        string groupName = "YourGroupName";
        GetUsersInGroup(groupName);
    }

    static void GetUsersInGroup(string groupName)
    {
        using (var context = new PrincipalContext(ContextType.Domain, null, "ldaps://YourDomainController:636", ContextOptions.SimpleBind))
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
