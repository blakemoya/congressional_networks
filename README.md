# Congressional Social Networks in R

Using data from [ProPublica's Bulk Data on Bills](https://www.propublica.org/datastore/dataset/congressional-data-bulk-legislation-bills) and an [API key](https://www.propublica.org/datastore/api/propublica-congress-api), these scripts generate and visualize cosponsor relationships between legislators.

<img src="https://i.imgur.com/w878Kwk.png" width="400" height="300" title="Collapsing casts"><img src="https://i.imgur.com/tMZOlix.png" width="400" height="300" title="Collapsing casts">

## Getting Started
### Prerequisites
- httr
- jsonlite
- igraph
- ggraph

### Usage

#### Downloads

Clone this repo with 

`git clone https://github.com/blakemoya/congressional_networks`

Use [this link](https://www.propublica.org/datastore/dataset/congressional-data-bulk-legislation-bills) to download a zip file containing data on all the bills introduced by a Congress in some particular year. The file will be named after that Congress's number (i.e. the 115th Congress will give you `115.zip`)
Extract the file/files of interest into the `congressional_networks` directory.

#### Configuration

Use [this link](https://www.propublica.org/datastore/api/propublica-congress-api) to request an API key.
Save the key emailed to you in a `.txt` file called `api_key.txt` followed by an empty line (i.e. copy and paste in the key, then press enter and save).
Copy this file into the `congressional_networks` directory.

Then, in line 5 of both `gen_graphfiles.R` and `gen_plots.R` set the variable `congress` to the congress you are interested in.
For instance, if I downloaded and extracted `115.zip`:

`congress = 115`

Once this is done, you can run `gen_graphfiles.R` (in RStudio, `Ctrl + A, Ctrl + Enter`) and then `gen_plots.R`. `gen_plots.R` takes a lot of time to produce house graphs, but the results are well worth it.

### Results

#### The 116th House
<p align="center">
  <img src="https://i.imgur.com/w878Kwk.png" width="640" height="480" title="Collapsing casts">
</p>

#### The 116th Senate
<p align="center">
  <img src="https://i.imgur.com/tMZOlix.png" width="640" height="480" title="Collapsing casts">
</p>
