: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cpms_t_account_equity_list_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_t_account_equity_list.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.id as id
    ,replace(replace(t.trade_date,chr(13),''),chr(10),'') as trade_date
    ,replace(replace(t.trade_time,chr(13),''),chr(10),'') as trade_time
    ,replace(replace(t.branch_no,chr(13),''),chr(10),'') as branch_no
    ,replace(replace(t.branch_no_name,chr(13),''),chr(10),'') as branch_no_name
    ,replace(replace(t.org_no,chr(13),''),chr(10),'') as org_no
    ,replace(replace(t.org_no_name,chr(13),''),chr(10),'') as org_no_name
    ,replace(replace(t.pty_id,chr(13),''),chr(10),'') as pty_id
    ,replace(replace(t.pty_name,chr(13),''),chr(10),'') as pty_name
    ,t.equity_count as equity_count
    ,t.equity_count_useble as equity_count_useble
    ,replace(replace(t.trade_channel,chr(13),''),chr(10),'') as trade_channel
    ,replace(replace(t.trade_type,chr(13),''),chr(10),'') as trade_type
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,replace(replace(t.attachment_path,chr(13),''),chr(10),'') as attachment_path
    ,replace(replace(t.attachment,chr(13),''),chr(10),'') as attachment
    ,replace(replace(t.last_ope_time,chr(13),''),chr(10),'') as last_ope_time
    ,replace(replace(t.final_oper_pers,chr(13),''),chr(10),'') as final_oper_pers
    ,replace(replace(t.memo_info,chr(13),''),chr(10),'') as memo_info
    ,replace(replace(t.glob_seq_num,chr(13),''),chr(10),'') as glob_seq_num
    ,replace(replace(t.mail_sbj,chr(13),''),chr(10),'') as mail_sbj
    ,replace(replace(t.mail_cntt,chr(13),''),chr(10),'') as mail_cntt
    ,replace(replace(t.mailbox_addr,chr(13),''),chr(10),'') as mailbox_addr
    ,replace(replace(t.mail_flag,chr(13),''),chr(10),'') as mail_flag
from iol.cpms_t_account_equity_list t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cpms_t_account_equity_list.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes