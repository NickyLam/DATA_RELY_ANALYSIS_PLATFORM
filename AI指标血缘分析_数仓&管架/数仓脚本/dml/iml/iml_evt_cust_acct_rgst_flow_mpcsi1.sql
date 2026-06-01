/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cust_acct_rgst_flow_mpcsi1
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
drop table ${iml_schema}.evt_cust_acct_rgst_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_cust_acct_rgst_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_cust_acct_rgst_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cust_acct_rgst_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_tran_code -- 中台交易码
    ,msg_type -- 报文类型
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,pbc_flow_num -- 人行流水号
    ,tran_tm -- 交易时间
    ,origi_bank_no -- 发起行行号
    ,recv_bank_no -- 接收行行号
    ,acct_rgst_bus_type_cd -- 账户注册业务类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,acct_attr_cd -- 账户属性代码
    ,onl_bank_sys_open_bank_no -- 网银系统开户行行号
    ,acct_num -- 账号
    ,acct_name -- 账户名称
    ,mask_acct_name -- 掩码账户名称
    ,acct_open_bank_no -- 账户开户行行号
    ,acct_clear_bank_no -- 账户清算行行号
    ,mobile_no -- 手机号码
    ,remark -- 备注
    ,wrtoff_bank_no -- 注销行行号
    ,new_acct_num -- 新账号
    ,new_acct_rgst_attr_cd -- 新账户注册属性代码
    ,new_acct_rgst_bank_no -- 新账户注册行行号
    ,cont_flg -- 往来标志
    ,bus_status_cd -- 业务状态代码
    ,bus_refuse_cd -- 业务拒绝代码
    ,pbc_proc_dt -- 人行处理日期
    ,err_info -- 错误信息
    ,rgst_status_cd -- 注册状态代码
    ,chn_id -- 渠道编号
    ,chn_flow_num -- 渠道流水号
    ,st_msg_ser_num -- 短信序列号
    ,init_pbc_flow_num -- 原人行流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cust_acct_rgst_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a10tibpsregeditlog-
insert into ${iml_schema}.evt_cust_acct_rgst_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_tran_code -- 中台交易码
    ,msg_type -- 报文类型
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,pbc_flow_num -- 人行流水号
    ,tran_tm -- 交易时间
    ,origi_bank_no -- 发起行行号
    ,recv_bank_no -- 接收行行号
    ,acct_rgst_bus_type_cd -- 账户注册业务类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,acct_attr_cd -- 账户属性代码
    ,onl_bank_sys_open_bank_no -- 网银系统开户行行号
    ,acct_num -- 账号
    ,acct_name -- 账户名称
    ,mask_acct_name -- 掩码账户名称
    ,acct_open_bank_no -- 账户开户行行号
    ,acct_clear_bank_no -- 账户清算行行号
    ,mobile_no -- 手机号码
    ,remark -- 备注
    ,wrtoff_bank_no -- 注销行行号
    ,new_acct_num -- 新账号
    ,new_acct_rgst_attr_cd -- 新账户注册属性代码
    ,new_acct_rgst_bank_no -- 新账户注册行行号
    ,cont_flg -- 往来标志
    ,bus_status_cd -- 业务状态代码
    ,bus_refuse_cd -- 业务拒绝代码
    ,pbc_proc_dt -- 人行处理日期
    ,err_info -- 错误信息
    ,rgst_status_cd -- 注册状态代码
    ,chn_id -- 渠道编号
    ,chn_flow_num -- 渠道流水号
    ,st_msg_ser_num -- 短信序列号
    ,init_pbc_flow_num -- 原人行流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102033'||P1.BUSINESSNO||P1.MSGOUTBANK -- 事件编号
    ,'9999' -- 法人编号
    ,P1.FUNCTION -- 中台交易码
    ,P1.PCKNO -- 报文类型
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.TRANSDT)) -- 交易日期
    ,P1.BUSINESSTRACE -- 交易流水号
    ,P1.BUSINESSNO -- 人行流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSTIME) -- 交易时间
    ,P1.MSGOUTBANK -- 发起行行号
    ,P1.MSGINBANK -- 接收行行号
    ,P1.FUNCTYPE -- 账户注册业务类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.IDTYPE  END -- 证件类型代码
    ,P1.IDCODE -- 证件号码
    ,nvl(trim(P1.DFTACCTTP),'-') -- 账户属性代码
    ,P1.REJECTBANK -- 网银系统开户行行号
    ,P1.ACCTNO -- 账号
    ,P1.ACCTNAME -- 账户名称
    ,P1.MSKACCTNAME -- 掩码账户名称
    ,P1.ACCTOPENBRN -- 账户开户行行号
    ,P1.SDFICODE -- 账户清算行行号
    ,P1.TEL -- 手机号码
    ,P1.REMARK -- 备注
    ,P1.CANCLEBANKS -- 注销行行号
    ,P1.NEWACCTNO -- 新账号
    ,nvl(trim(P1.NEWDFTACCTTP),'-') -- 新账户注册属性代码
    ,P1.NEWACCTBANK -- 新账户注册行行号
    ,P1.IOTYPE -- 往来标志
    ,nvl(trim(P1.PROCESSCODE),'-') -- 业务状态代码
    ,nvl(trim(P1.RSREJECTCODE),'-') -- 业务拒绝代码
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.PROCDT)) -- 人行处理日期
    ,P1.FILL -- 错误信息
    ,nvl(trim(P1.STATUS),'-')  -- 注册状态代码
    ,nvl(trim(P1.CHANNLID),'-') -- 渠道编号
    ,P1.TRANSSEQNO -- 渠道流水号
    ,P1.OTPSEQNO -- 短信序列号
    ,P1.ORGNLMSGID -- 原人行流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a10tibpsregeditlog' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a10tibpsregeditlog p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.IDTYPE  = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A10TIBPSREGEDITLOG'
        AND R1.SRC_FIELD_EN_NAME= 'IDTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CUST_ACCT_RGST_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
where  1 = 1 
    and P1.transdt = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_cust_acct_rgst_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_cust_acct_rgst_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_cust_acct_rgst_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cust_acct_rgst_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_cust_acct_rgst_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cust_acct_rgst_flow', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);