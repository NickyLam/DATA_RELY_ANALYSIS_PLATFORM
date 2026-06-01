/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_pbs_verify_channel_flow
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_verify_channel_flow_ex purge;
alter table ${iol_schema}.osbs_pbs_verify_channel_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.osbs_pbs_verify_channel_flow truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.osbs_pbs_verify_channel_flow_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_verify_channel_flow where 0=1;

insert /*+ append */ into ${iol_schema}.osbs_pbs_verify_channel_flow_ex(
    pvc_transdate -- 交易日期yyyyMMdd
    ,pvc_transtime -- 交易时间yyyyMMddHHmmssSSS
    ,pvc_branchname -- 分行名称
    ,pvc_branchcode -- 分行号
    ,pvc_sub_branchname -- 支行/网点
    ,pvc_sub_branchcode -- 支行号/网点号
    ,pvc_ecifno -- 客户号
    ,pvc_channel -- 交易渠道：NMB-手机银行；MPP-微银行小程序；XFA-零售贷款小程序；
    ,pvc_scene -- 场景
    ,pvc_verify_channel -- 鉴权通道:深金结SZFESC；城银清CBPS；银联CUPS；人行CBAC；CFCA；
    ,pvc_bankno -- 联行号
    ,pvc_bankname -- 行名
    ,pvc_cardno -- 卡号
    ,pvc_mobile -- 手机号
    ,pvc_result -- 鉴权结果：0成功；1失败；
    ,pvc_errorcode -- 响应码
    ,pvc_errormsg -- 响应信息
    ,pvc_token -- 交易token
    ,pvc_ecifname -- 客户名称
    ,pvc_acctno -- 账户
    ,pvc_acct_class -- 账户类型；1-类户；2二类户；3三类户
    ,pvc_idno -- 证件号码
    ,pvc_idtype -- 证件类型
    ,pvc_transflow -- 交易流水
    ,pvc_extend1 -- 备用字段1
    ,pvc_extend2 -- 备用字段2
    ,pvc_extend3 -- 备用字段3
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    pvc_transdate -- 交易日期yyyyMMdd
    ,pvc_transtime -- 交易时间yyyyMMddHHmmssSSS
    ,pvc_branchname -- 分行名称
    ,pvc_branchcode -- 分行号
    ,pvc_sub_branchname -- 支行/网点
    ,pvc_sub_branchcode -- 支行号/网点号
    ,pvc_ecifno -- 客户号
    ,pvc_channel -- 交易渠道：NMB-手机银行；MPP-微银行小程序；XFA-零售贷款小程序；
    ,pvc_scene -- 场景
    ,pvc_verify_channel -- 鉴权通道:深金结SZFESC；城银清CBPS；银联CUPS；人行CBAC；CFCA；
    ,pvc_bankno -- 联行号
    ,pvc_bankname -- 行名
    ,pvc_cardno -- 卡号
    ,pvc_mobile -- 手机号
    ,pvc_result -- 鉴权结果：0成功；1失败；
    ,pvc_errorcode -- 响应码
    ,pvc_errormsg -- 响应信息
    ,pvc_token -- 交易token
    ,pvc_ecifname -- 客户名称
    ,pvc_acctno -- 账户
    ,pvc_acct_class -- 账户类型；1-类户；2二类户；3三类户
    ,pvc_idno -- 证件号码
    ,pvc_idtype -- 证件类型
    ,pvc_transflow -- 交易流水
    ,pvc_extend1 -- 备用字段1
    ,pvc_extend2 -- 备用字段2
    ,pvc_extend3 -- 备用字段3
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.osbs_pbs_verify_channel_flow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.osbs_pbs_verify_channel_flow exchange partition p_${batch_date} with table ${iol_schema}.osbs_pbs_verify_channel_flow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_pbs_verify_channel_flow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.osbs_pbs_verify_channel_flow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_pbs_verify_channel_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);