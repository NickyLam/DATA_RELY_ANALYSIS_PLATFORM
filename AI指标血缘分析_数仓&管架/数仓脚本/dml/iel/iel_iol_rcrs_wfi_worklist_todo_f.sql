: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_wfi_worklist_todo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_wfi_worklist_todo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.instanceid,chr(13),''),chr(10),'') as instanceid
    ,replace(replace(t.wfstatus,chr(13),''),chr(10),'') as wfstatus
    ,replace(replace(t.wfid,chr(13),''),chr(10),'') as wfid
    ,replace(replace(t.wfname,chr(13),''),chr(10),'') as wfname
    ,replace(replace(t.wfsign,chr(13),''),chr(10),'') as wfsign
    ,replace(replace(t.wfjobname,chr(13),''),chr(10),'') as wfjobname
    ,replace(replace(t.wfstarttime,chr(13),''),chr(10),'') as wfstarttime
    ,replace(replace(t.wfplanendtime,chr(13),''),chr(10),'') as wfplanendtime
    ,replace(replace(t.wfappid,chr(13),''),chr(10),'') as wfappid
    ,replace(replace(t.wfappname,chr(13),''),chr(10),'') as wfappname
    ,replace(replace(t.wfadmin,chr(13),''),chr(10),'') as wfadmin
    ,replace(replace(t.wfreaders,chr(13),''),chr(10),'') as wfreaders
    ,replace(replace(t.wfarchiveendtime,chr(13),''),chr(10),'') as wfarchiveendtime
    ,replace(replace(t.bdraft,chr(13),''),chr(10),'') as bdraft
    ,replace(replace(t.author,chr(13),''),chr(10),'') as author
    ,replace(replace(t.appsign,chr(13),''),chr(10),'') as appsign
    ,replace(replace(t.spstatus,chr(13),''),chr(10),'') as spstatus
    ,replace(replace(t.depid,chr(13),''),chr(10),'') as depid
    ,replace(replace(t.orgid,chr(13),''),chr(10),'') as orgid
    ,replace(replace(t.formdata,chr(13),''),chr(10),'') as formdata
    ,replace(replace(t.sysid,chr(13),''),chr(10),'') as sysid
    ,replace(replace(t.prenodeid,chr(13),''),chr(10),'') as prenodeid
    ,replace(replace(t.prenodename,chr(13),''),chr(10),'') as prenodename
    ,replace(replace(t.nodeid,chr(13),''),chr(10),'') as nodeid
    ,replace(replace(t.nodename,chr(13),''),chr(10),'') as nodename
    ,replace(replace(t.nodesign,chr(13),''),chr(10),'') as nodesign
    ,replace(replace(t.nodestatus,chr(13),''),chr(10),'') as nodestatus
    ,replace(replace(t.nodeusermodifytype,chr(13),''),chr(10),'') as nodeusermodifytype
    ,replace(replace(t.wfnodeformid,chr(13),''),chr(10),'') as wfnodeformid
    ,replace(replace(t.wfnodeformflow,chr(13),''),chr(10),'') as wfnodeformflow
    ,replace(replace(t.nodestarttime,chr(13),''),chr(10),'') as nodestarttime
    ,replace(replace(t.nodeaccepttime,chr(13),''),chr(10),'') as nodeaccepttime
    ,replace(replace(t.nodeplanendtime,chr(13),''),chr(10),'') as nodeplanendtime
    ,replace(replace(t.currentnodeusers,chr(13),''),chr(10),'') as currentnodeusers
    ,replace(replace(t.currentnodeuser,chr(13),''),chr(10),'') as currentnodeuser
    ,replace(replace(t.originalusers,chr(13),''),chr(10),'') as originalusers
    ,replace(replace(t.preprocessorlist,chr(13),''),chr(10),'') as preprocessorlist
    ,replace(replace(t.allprocessor,chr(13),''),chr(10),'') as allprocessor
    ,replace(replace(t.allreaderslist,chr(13),''),chr(10),'') as allreaderslist
    ,replace(replace(t.announceuser,chr(13),''),chr(10),'') as announceuser
    ,replace(replace(t.isprocessed,chr(13),''),chr(10),'') as isprocessed
    ,replace(replace(t.table_name,chr(13),''),chr(10),'') as table_name
    ,replace(replace(t.pk_col,chr(13),''),chr(10),'') as pk_col
    ,replace(replace(t.pk_value,chr(13),''),chr(10),'') as pk_value
    ,replace(replace(t.appl_type,chr(13),''),chr(10),'') as appl_type
    ,replace(replace(t.appl_seq,chr(13),''),chr(10),'') as appl_seq
    ,replace(replace(t.prd_name,chr(13),''),chr(10),'') as prd_name
    ,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
    ,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
    ,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
    ,replace(replace(t.cert_code,chr(13),''),chr(10),'') as cert_code
    ,t.amt as amt
    ,t.term as term
    ,t.ruling_ir as ruling_ir
    ,t.reality_ir_y as reality_ir_y
    ,replace(replace(t.cont_no,chr(13),''),chr(10),'') as cont_no
    ,replace(replace(t.bill_no,chr(13),''),chr(10),'') as bill_no
    ,replace(replace(t.input_id,chr(13),''),chr(10),'') as input_id
    ,replace(replace(t.input_br_id,chr(13),''),chr(10),'') as input_br_id
    ,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
    ,replace(replace(t.owner,chr(13),''),chr(10),'') as owner
    ,replace(replace(t.wfi_start_user,chr(13),''),chr(10),'') as wfi_start_user
    ,replace(replace(t.wfi_start_node_id,chr(13),''),chr(10),'') as wfi_start_node_id
    ,replace(replace(t.current_scene_id,chr(13),''),chr(10),'') as current_scene_id
from iol.rcrs_wfi_worklist_todo t
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_wfi_worklist_todo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes