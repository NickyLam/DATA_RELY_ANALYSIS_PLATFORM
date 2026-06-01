/*
Purpose:    整全模型层-全量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_mercht_tran_clear_flow_mpcsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_mercht_tran_clear_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_mercht_tran_clear_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_mercht_tran_clear_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mercht_tran_clear_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sender_brac_org_id -- 发送方网点机构编号
    ,send_org_id -- 发送机构编号
    ,intior_flow_num -- 发起方流水号
    ,tran_trans_tm -- 交易传输时间
    ,tran_dt -- 交易日期
    ,cust_acct_id -- 客户账户编号
    ,tran_amt -- 交易金额
    ,msg_type_cd -- 报文类型代码
    ,tran_proc_cd -- 交易处理代码
    ,mercht_type_cd -- 商户类型代码
    ,mercht_id -- 商户编号
    ,tran_serv_point_cond_cd -- 交易服务点条件代码
    ,auth_reply_code -- 授权应答编码
    ,belong_clear_org_id -- 所属清算机构编号
    ,init_intior_flow_num -- 原发起方流水号
    ,tran_return_cd -- 交易返回代码
    ,tran_serv_point_input_way_cd -- 交易服务点输入方式代码
    ,paybl_chn_comm_fee -- 应付渠道手续费
    ,recvbl_chn_comm_fee -- 应收渠道手续费
    ,init_tran_tm -- 原交易时间
    ,card_iss_org_id -- 发卡机构编号
    ,termn_type_cd -- 终端类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_mercht_tran_clear_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a51ubzlacom-
insert into ${iml_schema}.evt_mercht_tran_clear_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sender_brac_org_id -- 发送方网点机构编号
    ,send_org_id -- 发送机构编号
    ,intior_flow_num -- 发起方流水号
    ,tran_trans_tm -- 交易传输时间
    ,tran_dt -- 交易日期
    ,cust_acct_id -- 客户账户编号
    ,tran_amt -- 交易金额
    ,msg_type_cd -- 报文类型代码
    ,tran_proc_cd -- 交易处理代码
    ,mercht_type_cd -- 商户类型代码
    ,mercht_id -- 商户编号
    ,tran_serv_point_cond_cd -- 交易服务点条件代码
    ,auth_reply_code -- 授权应答编码
    ,belong_clear_org_id -- 所属清算机构编号
    ,init_intior_flow_num -- 原发起方流水号
    ,tran_return_cd -- 交易返回代码
    ,tran_serv_point_input_way_cd -- 交易服务点输入方式代码
    ,paybl_chn_comm_fee -- 应付渠道手续费
    ,recvbl_chn_comm_fee -- 应收渠道手续费
    ,init_tran_tm -- 原交易时间
    ,card_iss_org_id -- 发卡机构编号
    ,termn_type_cd -- 终端类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201011'||p1.ACQINSTID||p1.FWDINSTID||p1.SYSTRACE||p1.TRANSTIME -- 事件编号
    ,'9999' -- 法人编号
    ,p1.ACQINSTID -- 发送方网点机构编号
    ,p1.FWDINSTID -- 发送机构编号
    ,p1.SYSTRACE -- 发起方流水号
    ,p1.TRANSTIME -- 交易传输时间
    ,${iml_schema}.DATEFORMAT_MIN(p1.TRANSDATE) -- 交易日期
    ,p1.PRIACCT -- 客户账户编号
    ,to_number(substr(p1.TRANSAMT,1,10)||'.'||substr(p1.TRANSAMT,11,2)) -- 交易金额
    ,p1.MSGTYPE -- 报文类型代码
    ,p1.PROCECODE -- 交易处理代码
    ,p1.MCHNTTYPE -- 商户类型代码
    ,p1.ACCPTRID -- 商户编号
    ,p1.SERVICECODE -- 交易服务点条件代码
    ,p1.AUTHRIDRESP -- 授权应答编码
    ,p1.RCVINSTID -- 所属清算机构编号
    ,p1.OLDSYSTRACE -- 原发起方流水号
    ,p1.RESPCODE -- 交易返回代码
    ,p1.POSENTRYMODE -- 交易服务点输入方式代码
    ,to_number(substr(p1.DUEHANDCHRG,1,10)||'.'||substr(p1.DUEHANDCHRG,11,2)) -- 应付渠道手续费
    ,to_number(substr(p1.RCVHANDCHRG,1,10)||'.'||substr(p1.RCVHANDCHRG,11,2)) -- 应收渠道手续费
    ,p1.OLDTRANSTIME -- 原交易时间
    ,p1.ISSURINSTID -- 发卡机构编号
    ,p1.TERMTYPE -- 终端类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a51ubzlacom' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a51ubzlacom p1
where  1 = 1 
--and transdate='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_mercht_tran_clear_flow truncate partition p_mpcsi1;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_mercht_tran_clear_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_mercht_tran_clear_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_mercht_tran_clear_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_mercht_tran_clear_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_mercht_tran_clear_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);