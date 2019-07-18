using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Serialization;

namespace Xml_Reader_Writer
{
    public partial class Form1 : Form
    {
        string filenameSax = "bücherSAX.xml";
        string filenameSerial = "bücherSerial.xml";
        public Form1()
        {
            InitializeComponent();
        }

        private void Button1_Click(object sender, EventArgs e)
        {
            var liste = new List<Book>();
            var ran = new Random();
            for (int i = 0; i < 100; i++)
            {
                liste.Add(new Book()
                {
                    Id = i,
                    Title = $"Buchtitel #{i:000}",
                    PageCount = ran.Next(60, 600),
                    Price = (decimal)ran.NextDouble() * 100m,
                    PubDate = DateTime.Now.AddDays(i * 37 * -1),
                    ISBN = $"AAA-BBB-CCC"
                });
            }
            dataGridView1.DataSource = liste;
        }


        private void Button2_Click(object sender, EventArgs e)
        {
            //SAX
            var sett = new XmlWriterSettings() { Indent = true };
            using (var xw = XmlWriter.Create(filenameSax, sett))
            {
                xw.WriteStartDocument();
                xw.WriteStartElement("Books");
                foreach (var item in (IEnumerable<Book>)dataGridView1.DataSource)
                {
                    xw.WriteStartElement("Book");
                    xw.WriteAttributeString("ISBN", item.ISBN);
                    xw.WriteElementString("Titel", item.Title);
                    xw.WriteEndElement(); //Book
                }
                xw.WriteEndElement(); //Books
                xw.WriteEndDocument();
            }

        }

        private void Button3_Click(object sender, EventArgs e)
        {
            var imported = new List<Book>();

            using (var xr = XmlReader.Create(filenameSax))
            {
                Book b = null;
                while (xr.Read())
                {
                    Debug.WriteLine($"{xr.Name}");
                    if (xr.Name == "Book" && xr.IsStartElement())
                    {
                        b = new Book();
                        imported.Add(b);
                        b.ISBN = xr.GetAttribute("ISBN");
                    }

                    if (xr.Name == "Titel" && xr.IsStartElement())
                    {
                        b.Title = xr.ReadElementContentAsString();
                    }
                }
            }
            dataGridView1.DataSource = imported;
        }

        private void Button4_Click(object sender, EventArgs e)
        {
            var xDoc = new XmlDocument();
            xDoc.Load(filenameSax);
            //xDoc.ChildNodes[5].Attributes.Append(new XmlAttribute("qwdwq") { Name = "BLÖ", Value = "12" });
            foreach (XmlNode item in xDoc.ChildNodes)
            {
                Debug.WriteLine($"{item.Name}");
                foreach (XmlNode item2 in item.ChildNodes)
                {
                    item2.InnerText = "lala";
                    Debug.WriteLine($"\t{item2.Name}");
                }
            }
            xDoc.Save(filenameSax);
        }

        private void Button5_Click(object sender, EventArgs e)
        {
            using (var sw = new StreamWriter(filenameSerial))
            {
                var serial = new XmlSerializer(typeof(List<Book>));
                serial.Serialize(sw, dataGridView1.DataSource);
            }
        }

        private void Button6_Click(object sender, EventArgs e)
        {
            using (var sr = new StreamReader(filenameSerial))
            {
                var serial = new XmlSerializer(typeof(List<Book>));
                dataGridView1.DataSource = serial.Deserialize(sr);
            }
        }

        private void Button7_Click(object sender, EventArgs e)
        {
            var url = "https://www.googleapis.com/books/v1/volumes?q=Eis";
            using (var wc = new WebClient())
            {
                wc.Encoding = Encoding.UTF8;
                var json = wc.DownloadString(url);
                var gBooks = JsonConvert.DeserializeObject<Rootobject>(json);
                dataGridView1.DataSource = gBooks.items.Select(x => x.volumeInfo).ToList();
            }
        }

        private void Button8_Click(object sender, EventArgs e)
        {
            using (var client = new ServiceReference1.BLZServicePortTypeClient("BLZServiceSOAP12port_http"))
            {
                var result = client.getBank("66762332");
                MessageBox.Show($"{result.bic} {result.bezeichnung} {result.plz} {result.ort}");
            }
        }
    }

    public class Book
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string ISBN { get; set; }
        public DateTime PubDate { get; set; }
        public int PageCount { get; set; }
        public decimal Price { get; set; }
    }
}
