/*
    New style BAM reader. This file is part of Sambamba.
    Copyright (C) 2017 Pjotr Prins <pjotr.prins@thebird.nl>

    Sambamba is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License,
    or (at your option) any later version.

    Sambamba is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
    02111-1307 USA

*/

// This is a complete rewrite of Artem Tarasov's original reader.

module sambamba.bio2.bam.header;

/*
import std.conv;
import core.stdc.stdio: fopen, fread, fclose;
import std.file;
import std.stdio;
import std.string;
import std.typecons;
import std.bitmanip;

import bio.bam.cigar;
*/

import std.exception;

import bio.bam.constants;

import sambamba.bio2.bgzf;
import sambamba.bio2.constants;

struct RefSequence {
  size_d length;
  string name;
}

struct Header {
  string id;
  string text;
  RefSequence[] refs;

  @disable this(this); // disable copy semantics;
}

void fetch_bam_header(ref Header header, ref BgzfStream stream) {
  ubyte[4] ubyte4;
  stream.read(ubyte4);
  enforce(ubyte4 == BAM_MAGIC,"Invalid file format: expected BAM magic number");
  immutable text_size = stream.read!int();
  immutable text = stream.read!string(text_size);
  header = Header(BAM_MAGIC,text);
  immutable n_refs = stream.read!int();
  foreach(int n_ref; 0..n_refs) {
    immutable l_name = stream.read!int();
    auto ref_name = stream.read!string(l_name);
    immutable l_ref = stream.read!int();
    header.refs ~= RefSequence(l_ref,ref_name);
  }
}
