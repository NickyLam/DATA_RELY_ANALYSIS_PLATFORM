#!bin/sh
##############################################################
source ~/.bash_profile

batch_date=`date -d "-91 day" +"%Y%m%d"`
echo "alter table iol.pams_pam_aum drop partition p_${batch_date};"

password=`python $ETL_HOME/script/decodepasswd.py iol`
sqlplus -S iol/$password@edwdb <<EOF
spool pams_pam_aum.log

alter table iol.pams_pam_aum drop partition p_${batch_date};

spool off
exit;
EOF

echo '***  删除分区执行完成 ！！  ***'

