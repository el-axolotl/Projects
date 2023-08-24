using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Management;

namespace Uninstall_Program
{
    class Program
    {
        static void Main(string[] args)
        {
            UninstallProgram(args[0]);
        }

        /// <summary>
        /// A method that tries to uninstall a program
        /// </summary>
        /// <param name="program">The program you want to uninstall</param>
        /// <returns></returns>
        private static bool UninstallProgram(string program)
        {
            bool uninstalled = false;
            try
            {
                ManagementObjectSearcher mos = new ManagementObjectSearcher("SELECT * FROM Win32_Product");
                foreach (ManagementObject mo in mos.Get())
                {
                    try
                    {
                        string name = mo["Name"].ToString();

                        if (name.Contains(program))
                        {
                            try
                            {
                                object hr = mo.InvokeMethod("Uninstall", null);
                                Console.WriteLine(mo["Name"] + " uninstalled");
                                uninstalled = true;
                            }
                            catch (Exception e)
                            {
                                //The program may not have a name property, so an exception will be thrown
                            }
                        }
                    }
                    catch(Exception e)
                    {

                    }
                }
                // Program was not found
                return uninstalled;
            }
            catch (Exception e)
            {
                return uninstalled;
            }
        }
    }
}
