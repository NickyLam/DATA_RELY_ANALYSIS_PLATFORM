/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_insure_tran_flow_inssf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_insure_tran_flow add partition p_inssf1 values ('inssf1')(
        subpartition p_inssf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_inssf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_insure_tran_flow_inssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_insure_tran_flow partition for ('inssf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_insure_tran_flow_inssf1_tm purge;
drop table ${iml_schema}.evt_insure_tran_flow_inssf1_op purge;
drop table ${iml_schema}.evt_insure_tran_flow_inssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_insure_tran_flow_inssf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_dt -- 交易日期
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,insure_pl_num -- 保险单号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,tran_cd -- 交易代码
    ,tran_cd_name -- 交易代码名称
    ,bank_acct_id -- 银行账户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,tran_org_id -- 交易机构编号
    ,operr_id -- 操作员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_chn_cd -- 交易渠道代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,policy_dt -- 保单日期
    ,policy_cfm_flow_num -- 保单确认流水号
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,host_tran_cd -- 主机交易代码
    ,host_return_code -- 主机返回码
    ,host_return_info -- 主机返回信息
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,insure_print_id -- 保险打印单编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_insure_tran_flow partition for ('inssf1')
where 0=1
;

create table ${iml_schema}.evt_insure_tran_flow_inssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_insure_tran_flow partition for ('inssf1') where 0=1;

create table ${iml_schema}.evt_insure_tran_flow_inssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_insure_tran_flow partition for ('inssf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbinsurereq-
insert into ${iml_schema}.evt_insure_tran_flow_inssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_dt -- 交易日期
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,insure_pl_num -- 保险单号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,tran_cd -- 交易代码
    ,tran_cd_name -- 交易代码名称
    ,bank_acct_id -- 银行账户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,tran_org_id -- 交易机构编号
    ,operr_id -- 操作员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_chn_cd -- 交易渠道代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,policy_dt -- 保单日期
    ,policy_cfm_flow_num -- 保单确认流水号
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,host_tran_cd -- 主机交易代码
    ,host_return_code -- 主机返回码
    ,host_return_info -- 主机返回信息
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,insure_print_id -- 保险打印单编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104021'||TO_CHAR(P1.TRANS_DATE)||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_max(to_char(P1.TRANS_DATE)) -- 交易日期
    ,P1.SERIAL_NO -- 流水号
    ,P1.ASSO_SERIAL -- 关联流水号
    ,P1.TA_CODE -- TA代码
    ,P1.PRD_CODE -- 产品编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||nvl(substr(P2.control_flag, 9, 1),' ') END -- 标准产品编号
    ,P1.INSURE_NO -- 保险单号
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,P1.CLIENT_NO -- 客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.TRANS_CODE -- 交易代码
    ,P1.TRANS_NAME -- 交易代码名称
    ,P1.BANK_ACC -- 银行账户编号
    ,decode(P1.VOUCHER_TYPE,'1','702','2','0','3','0','6','713',' ','-',P1.VOUCHER_TYPE) -- 凭证类型代码
    ,P1.VOUCHER_NO -- 凭证编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,P1.AMT -- 交易金额
    ,P1.CHARGE -- 手续费
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPER_NO -- 操作员编号
    ,P1.AUTH_OPER -- 授权柜员编号
    ,nvl(trim(P1.CHANNEL),'-') -- 交易渠道代码
    ,P1.ERR_CODE -- 返回码
    ,P1.ERR_MSG -- 返回信息
    ,${iml_schema}.dateformat_max(to_char(P1.INSURE_DATE)) -- 保单日期
    ,P1.INSURE_CFM_NO -- 保单确认流水号
    ,${iml_schema}.dateformat_max(to_char(P1.HOST_DATE)) -- 主机日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,P1.HOST_TRANS_CODE -- 主机交易代码
    ,P1.HOST_ERR_CODE -- 主机返回码
    ,P1.HOST_ERR_MSG -- 主机返回信息
    ,NVL(TRIM(P1.STATUS),'-') -- 交易状态代码
    ,SUBSTR(LPAD(P1.TRANS_TIME,6,'0'),1,2)||':'||SUBSTR(LPAD(P1.TRANS_TIME,6,'0'),3,2)||':'||SUBSTR(LPAD(P1.TRANS_TIME,6,'0'),5,2) -- 交易时间
    ,P1.INSURE_PRINT -- 保险打印单编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbinsurereq' -- 源表名称
    ,'inssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbinsurereq p1
    left join ${iol_schema}.ifms_tbinsureproduct p2 on P1.PRD_CODE=P2.PRD_CODE
and P1.ta_code=P2.ta_code
and  p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r4 on nvl(substr(P2.control_flag, 9, 1),' ') = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IFMS'
        AND R4.SRC_TAB_EN_NAME= 'IFMS_TBINSUREPRODUCT'
        AND R4.SRC_FIELD_EN_NAME= 'CONTROL_FLAG'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_INSURE_TRAN_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'STD_PROD_ID'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBINSUREREQ'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_INSURE_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CURR_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_TBINSUREREQ'
        AND R3.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_INSURE_TRAN_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_insure_tran_flow_inssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_dt -- 交易日期
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,insure_pl_num -- 保险单号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,tran_cd -- 交易代码
    ,tran_cd_name -- 交易代码名称
    ,bank_acct_id -- 银行账户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,tran_org_id -- 交易机构编号
    ,operr_id -- 操作员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_chn_cd -- 交易渠道代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,policy_dt -- 保单日期
    ,policy_cfm_flow_num -- 保单确认流水号
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,host_tran_cd -- 主机交易代码
    ,host_return_code -- 主机返回码
    ,host_return_info -- 主机返回信息
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,insure_print_id -- 保险打印单编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_insure_tran_flow_inssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_dt -- 交易日期
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,insure_pl_num -- 保险单号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,tran_cd -- 交易代码
    ,tran_cd_name -- 交易代码名称
    ,bank_acct_id -- 银行账户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,tran_org_id -- 交易机构编号
    ,operr_id -- 操作员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_chn_cd -- 交易渠道代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,policy_dt -- 保单日期
    ,policy_cfm_flow_num -- 保单确认流水号
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,host_tran_cd -- 主机交易代码
    ,host_return_code -- 主机返回码
    ,host_return_info -- 主机返回信息
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,insure_print_id -- 保险打印单编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.rela_flow_num, o.rela_flow_num) as rela_flow_num -- 关联流水号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.insure_pl_num, o.insure_pl_num) as insure_pl_num -- 保险单号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 交易代码
    ,nvl(n.tran_cd_name, o.tran_cd_name) as tran_cd_name -- 交易代码名称
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.vouch_type_cd, o.vouch_type_cd) as vouch_type_cd -- 凭证类型代码
    ,nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.comm_fee, o.comm_fee) as comm_fee -- 手续费
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.operr_id, o.operr_id) as operr_id -- 操作员编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道代码
    ,nvl(n.return_code, o.return_code) as return_code -- 返回码
    ,nvl(n.return_info, o.return_info) as return_info -- 返回信息
    ,nvl(n.policy_dt, o.policy_dt) as policy_dt -- 保单日期
    ,nvl(n.policy_cfm_flow_num, o.policy_cfm_flow_num) as policy_cfm_flow_num -- 保单确认流水号
    ,nvl(n.host_dt, o.host_dt) as host_dt -- 主机日期
    ,nvl(n.host_flow_num, o.host_flow_num) as host_flow_num -- 主机流水号
    ,nvl(n.host_tran_cd, o.host_tran_cd) as host_tran_cd -- 主机交易代码
    ,nvl(n.host_return_code, o.host_return_code) as host_return_code -- 主机返回码
    ,nvl(n.host_return_info, o.host_return_info) as host_return_info -- 主机返回信息
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.insure_print_id, o.insure_print_id) as insure_print_id -- 保险打印单编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_insure_tran_flow_inssf1_tm n
    full join (select * from ${iml_schema}.evt_insure_tran_flow_inssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.tran_dt <> n.tran_dt
        or o.flow_num <> n.flow_num
        or o.rela_flow_num <> n.rela_flow_num
        or o.ta_cd <> n.ta_cd
        or o.prod_id <> n.prod_id
        or o.std_prod_id <> n.std_prod_id
        or o.insure_pl_num <> n.insure_pl_num
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.cust_id <> n.cust_id
        or o.cust_type_cd <> n.cust_type_cd
        or o.tran_cd <> n.tran_cd
        or o.tran_cd_name <> n.tran_cd_name
        or o.bank_acct_id <> n.bank_acct_id
        or o.vouch_type_cd <> n.vouch_type_cd
        or o.vouch_id <> n.vouch_id
        or o.curr_cd <> n.curr_cd
        or o.tran_amt <> n.tran_amt
        or o.comm_fee <> n.comm_fee
        or o.tran_org_id <> n.tran_org_id
        or o.operr_id <> n.operr_id
        or o.auth_teller_id <> n.auth_teller_id
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.return_code <> n.return_code
        or o.return_info <> n.return_info
        or o.policy_dt <> n.policy_dt
        or o.policy_cfm_flow_num <> n.policy_cfm_flow_num
        or o.host_dt <> n.host_dt
        or o.host_flow_num <> n.host_flow_num
        or o.host_tran_cd <> n.host_tran_cd
        or o.host_return_code <> n.host_return_code
        or o.host_return_info <> n.host_return_info
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_tm <> n.tran_tm
        or o.insure_print_id <> n.insure_print_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_insure_tran_flow_inssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_dt -- 交易日期
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,insure_pl_num -- 保险单号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,tran_cd -- 交易代码
    ,tran_cd_name -- 交易代码名称
    ,bank_acct_id -- 银行账户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,tran_org_id -- 交易机构编号
    ,operr_id -- 操作员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_chn_cd -- 交易渠道代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,policy_dt -- 保单日期
    ,policy_cfm_flow_num -- 保单确认流水号
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,host_tran_cd -- 主机交易代码
    ,host_return_code -- 主机返回码
    ,host_return_info -- 主机返回信息
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,insure_print_id -- 保险打印单编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_insure_tran_flow_inssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_dt -- 交易日期
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,insure_pl_num -- 保险单号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,tran_cd -- 交易代码
    ,tran_cd_name -- 交易代码名称
    ,bank_acct_id -- 银行账户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,tran_org_id -- 交易机构编号
    ,operr_id -- 操作员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_chn_cd -- 交易渠道代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,policy_dt -- 保单日期
    ,policy_cfm_flow_num -- 保单确认流水号
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,host_tran_cd -- 主机交易代码
    ,host_return_code -- 主机返回码
    ,host_return_info -- 主机返回信息
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,insure_print_id -- 保险打印单编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.tran_dt -- 交易日期
    ,o.flow_num -- 流水号
    ,o.rela_flow_num -- 关联流水号
    ,o.ta_cd -- TA代码
    ,o.prod_id -- 产品编号
    ,o.std_prod_id -- 标准产品编号
    ,o.insure_pl_num -- 保险单号
    ,o.cust_mgr_id -- 客户经理编号
    ,o.cust_id -- 客户编号
    ,o.cust_type_cd -- 客户类型代码
    ,o.tran_cd -- 交易代码
    ,o.tran_cd_name -- 交易代码名称
    ,o.bank_acct_id -- 银行账户编号
    ,o.vouch_type_cd -- 凭证类型代码
    ,o.vouch_id -- 凭证编号
    ,o.curr_cd -- 币种代码
    ,o.tran_amt -- 交易金额
    ,o.comm_fee -- 手续费
    ,o.tran_org_id -- 交易机构编号
    ,o.operr_id -- 操作员编号
    ,o.auth_teller_id -- 授权柜员编号
    ,o.tran_chn_cd -- 交易渠道代码
    ,o.return_code -- 返回码
    ,o.return_info -- 返回信息
    ,o.policy_dt -- 保单日期
    ,o.policy_cfm_flow_num -- 保单确认流水号
    ,o.host_dt -- 主机日期
    ,o.host_flow_num -- 主机流水号
    ,o.host_tran_cd -- 主机交易代码
    ,o.host_return_code -- 主机返回码
    ,o.host_return_info -- 主机返回信息
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_tm -- 交易时间
    ,o.insure_print_id -- 保险打印单编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_insure_tran_flow_inssf1_bk o
    left join ${iml_schema}.evt_insure_tran_flow_inssf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_insure_tran_flow_inssf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_insure_tran_flow;
alter table ${iml_schema}.evt_insure_tran_flow truncate partition for ('inssf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_insure_tran_flow exchange subpartition p_inssf1_19000101 with table ${iml_schema}.evt_insure_tran_flow_inssf1_cl;
alter table ${iml_schema}.evt_insure_tran_flow exchange subpartition p_inssf1_20991231 with table ${iml_schema}.evt_insure_tran_flow_inssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_insure_tran_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_insure_tran_flow_inssf1_tm purge;
drop table ${iml_schema}.evt_insure_tran_flow_inssf1_op purge;
drop table ${iml_schema}.evt_insure_tran_flow_inssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_insure_tran_flow_inssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_insure_tran_flow', partname => 'p_inssf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
