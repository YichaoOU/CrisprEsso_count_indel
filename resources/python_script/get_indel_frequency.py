#!/usr/bin/env python


import sys
import glob

import pandas as pd



indel_file = glob.glob("*/CRISPResso_quantification_of_editing_frequency.txt")[0]
indel_df = pd.read_csv(indel_file,sep="\t")
Mod = indel_df.at[0,"Modified"]
only_sub = indel_df.at[0,"Only Substitutions"]
total = int(indel_df.at[0,"Reads_aligned"])
indel_reads = int(Mod-only_sub)
indel = float(indel_reads)/total
out = [total,indel_reads,indel]
out = pd.DataFrame(out).T
out.columns = ['Total reads','indel reads','indel frequency']
out.to_csv("indel_frequency.csv",index=False)







