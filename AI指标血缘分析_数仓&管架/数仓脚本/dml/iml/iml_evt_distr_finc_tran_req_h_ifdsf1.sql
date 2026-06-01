/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_distr_finc_tran_req_h_ifdsf1
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
alter table ${iml_schema}.evt_distr_finc_tran_req_h add partition p_ifdsf1 values ('ifdsf1')(
        subpartition p_ifdsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ifdsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_distr_finc_tran_req_h partition for ('ifdsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_tm purge;
drop table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_op purge;
drop table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_cd -- 业务代码
    ,ta_cd -- TA代码
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,appl_flow_num -- 申请流水号
    ,seller_id -- 销售商编号
    ,tran_org_id -- 交易机构编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,finc_prod_id -- 理财产品编号
    ,lot_cate_cd -- 份额类别代码
    ,appl_amt -- 申请金额
    ,appl_shares -- 申请份数
    ,init_appl_flow_num -- 原申请流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,divd_way_cd -- 分红方式代码
    ,ta_init_flg -- TA发起标志
    ,ext_bus_cd -- 外部业务代码
    ,ta_manu_check_flg -- TA人工审核标志
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,cfm_dt -- 确认日期
    ,status_cd -- 状态代码
    ,cfm_amt -- 确认金额
    ,tran_chn_cd -- 交易渠道代码
    ,bank_id -- 银行编号
    ,redem_mode_cd -- 赎回模式代码
    ,return_info -- 返回信息
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_distr_finc_tran_req_h partition for ('ifdsf1')
where 0=1
;

create table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_distr_finc_tran_req_h partition for ('ifdsf1') where 0=1;

create table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_distr_finc_tran_req_h partition for ('ifdsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_fds_tbtatransreq-
insert into ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_cd -- 业务代码
    ,ta_cd -- TA代码
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,appl_flow_num -- 申请流水号
    ,seller_id -- 销售商编号
    ,tran_org_id -- 交易机构编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,finc_prod_id -- 理财产品编号
    ,lot_cate_cd -- 份额类别代码
    ,appl_amt -- 申请金额
    ,appl_shares -- 申请份数
    ,init_appl_flow_num -- 原申请流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,divd_way_cd -- 分红方式代码
    ,ta_init_flg -- TA发起标志
    ,ext_bus_cd -- 外部业务代码
    ,ta_manu_check_flg -- TA人工审核标志
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,cfm_dt -- 确认日期
    ,status_cd -- 状态代码
    ,cfm_amt -- 确认金额
    ,tran_chn_cd -- 交易渠道代码
    ,bank_id -- 银行编号
    ,redem_mode_cd -- 赎回模式代码
    ,return_info -- 返回信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104031'||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BUSIN_CODE -- 业务代码
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANS_DATE) -- 申请日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANS_DATE||LPAD(P1.TRANS_TIME,6,'0')) -- 申请时间
    ,P1.SERIAL_NO -- 申请流水号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.PRD_CODE -- 产品编号
    ,P1.REAL_PRD_CODE -- 理财产品编号
    ,NVL(TRIM(P1.SHARE_CLASS),'-') -- 份额类别代码
    ,P1.AMT -- 申请金额
    ,P1.VOL -- 申请份数
    ,P1.ORI_SERIAL_NO -- 原申请流水号
    ,P1.ORI_CFM_NO -- 原确认流水号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DIV_MODE END -- 分红方式代码
    ,NVL(TRIM(P1.TA_FLAG),'-') -- TA发起标志
    ,P1.OUT_BUSIN_CODE -- 外部业务代码
    ,NVL(TRIM(P1.MAN_FLAG),'-') -- TA人工审核标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.LAST_CFM_DATE) -- 确认日期
    ,NVL(TRIM(P1.STATUS),'-') -- 状态代码
    ,P1.CFM_AMT -- 确认金额
    ,NVL(TRIM(P1.CHANNEL),'-')  -- 交易渠道代码
    ,P1.BANK_NO -- 银行编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.RED_MODE END -- 赎回模式代码
    ,P1.ERR_MSG -- 返回信息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_fds_tbtatransreq' -- 源表名称
    ,'ifdsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_fds_tbtatransreq p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DIV_MODE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_FDS_TBTATRANSREQ'
        AND R1.SRC_FIELD_EN_NAME= 'DIV_MODE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_DISTR_FINC_TRAN_REQ_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'DIVD_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CLIENT_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_FDS_TBTATRANSREQ'
        AND R2.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_DISTR_FINC_TRAN_REQ_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.RED_MODE= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IFMS'
        AND R4.SRC_TAB_EN_NAME= 'IFMS_FDS_TBTATRANSREQ'
        AND R4.SRC_FIELD_EN_NAME= 'RED_MODE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_DISTR_FINC_TRAN_REQ_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'REDEM_MODE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_cd -- 业务代码
    ,ta_cd -- TA代码
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,appl_flow_num -- 申请流水号
    ,seller_id -- 销售商编号
    ,tran_org_id -- 交易机构编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,finc_prod_id -- 理财产品编号
    ,lot_cate_cd -- 份额类别代码
    ,appl_amt -- 申请金额
    ,appl_shares -- 申请份数
    ,init_appl_flow_num -- 原申请流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,divd_way_cd -- 分红方式代码
    ,ta_init_flg -- TA发起标志
    ,ext_bus_cd -- 外部业务代码
    ,ta_manu_check_flg -- TA人工审核标志
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,cfm_dt -- 确认日期
    ,status_cd -- 状态代码
    ,cfm_amt -- 确认金额
    ,tran_chn_cd -- 交易渠道代码
    ,bank_id -- 银行编号
    ,redem_mode_cd -- 赎回模式代码
    ,return_info -- 返回信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_cd -- 业务代码
    ,ta_cd -- TA代码
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,appl_flow_num -- 申请流水号
    ,seller_id -- 销售商编号
    ,tran_org_id -- 交易机构编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,finc_prod_id -- 理财产品编号
    ,lot_cate_cd -- 份额类别代码
    ,appl_amt -- 申请金额
    ,appl_shares -- 申请份数
    ,init_appl_flow_num -- 原申请流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,divd_way_cd -- 分红方式代码
    ,ta_init_flg -- TA发起标志
    ,ext_bus_cd -- 外部业务代码
    ,ta_manu_check_flg -- TA人工审核标志
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,cfm_dt -- 确认日期
    ,status_cd -- 状态代码
    ,cfm_amt -- 确认金额
    ,tran_chn_cd -- 交易渠道代码
    ,bank_id -- 银行编号
    ,redem_mode_cd -- 赎回模式代码
    ,return_info -- 返回信息
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
    ,nvl(n.bus_cd, o.bus_cd) as bus_cd -- 业务代码
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.appl_tm, o.appl_tm) as appl_tm -- 申请时间
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.seller_id, o.seller_id) as seller_id -- 销售商编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.finc_acct_id, o.finc_acct_id) as finc_acct_id -- 理财账户编号
    ,nvl(n.ta_tran_acct_id, o.ta_tran_acct_id) as ta_tran_acct_id -- TA交易账户编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,nvl(n.lot_cate_cd, o.lot_cate_cd) as lot_cate_cd -- 份额类别代码
    ,nvl(n.appl_amt, o.appl_amt) as appl_amt -- 申请金额
    ,nvl(n.appl_shares, o.appl_shares) as appl_shares -- 申请份数
    ,nvl(n.init_appl_flow_num, o.init_appl_flow_num) as init_appl_flow_num -- 原申请流水号
    ,nvl(n.init_cfm_flow_num, o.init_cfm_flow_num) as init_cfm_flow_num -- 原确认流水号
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.ta_init_flg, o.ta_init_flg) as ta_init_flg -- TA发起标志
    ,nvl(n.ext_bus_cd, o.ext_bus_cd) as ext_bus_cd -- 外部业务代码
    ,nvl(n.ta_manu_check_flg, o.ta_manu_check_flg) as ta_manu_check_flg -- TA人工审核标志
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.finc_cust_id, o.finc_cust_id) as finc_cust_id -- 理财客户编号
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 确认日期
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.cfm_amt, o.cfm_amt) as cfm_amt -- 确认金额
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道代码
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行编号
    ,nvl(n.redem_mode_cd, o.redem_mode_cd) as redem_mode_cd -- 赎回模式代码
    ,nvl(n.return_info, o.return_info) as return_info -- 返回信息
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
from ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_tm n
    full join (select * from ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.bus_cd <> n.bus_cd
        or o.ta_cd <> n.ta_cd
        or o.appl_dt <> n.appl_dt
        or o.appl_tm <> n.appl_tm
        or o.appl_flow_num <> n.appl_flow_num
        or o.seller_id <> n.seller_id
        or o.tran_org_id <> n.tran_org_id
        or o.finc_acct_id <> n.finc_acct_id
        or o.ta_tran_acct_id <> n.ta_tran_acct_id
        or o.prod_id <> n.prod_id
        or o.finc_prod_id <> n.finc_prod_id
        or o.lot_cate_cd <> n.lot_cate_cd
        or o.appl_amt <> n.appl_amt
        or o.appl_shares <> n.appl_shares
        or o.init_appl_flow_num <> n.init_appl_flow_num
        or o.init_cfm_flow_num <> n.init_cfm_flow_num
        or o.divd_way_cd <> n.divd_way_cd
        or o.ta_init_flg <> n.ta_init_flg
        or o.ext_bus_cd <> n.ext_bus_cd
        or o.ta_manu_check_flg <> n.ta_manu_check_flg
        or o.cust_type_cd <> n.cust_type_cd
        or o.finc_cust_id <> n.finc_cust_id
        or o.cfm_dt <> n.cfm_dt
        or o.status_cd <> n.status_cd
        or o.cfm_amt <> n.cfm_amt
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.bank_id <> n.bank_id
        or o.redem_mode_cd <> n.redem_mode_cd
        or o.return_info <> n.return_info
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_cd -- 业务代码
    ,ta_cd -- TA代码
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,appl_flow_num -- 申请流水号
    ,seller_id -- 销售商编号
    ,tran_org_id -- 交易机构编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,finc_prod_id -- 理财产品编号
    ,lot_cate_cd -- 份额类别代码
    ,appl_amt -- 申请金额
    ,appl_shares -- 申请份数
    ,init_appl_flow_num -- 原申请流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,divd_way_cd -- 分红方式代码
    ,ta_init_flg -- TA发起标志
    ,ext_bus_cd -- 外部业务代码
    ,ta_manu_check_flg -- TA人工审核标志
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,cfm_dt -- 确认日期
    ,status_cd -- 状态代码
    ,cfm_amt -- 确认金额
    ,tran_chn_cd -- 交易渠道代码
    ,bank_id -- 银行编号
    ,redem_mode_cd -- 赎回模式代码
    ,return_info -- 返回信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_cd -- 业务代码
    ,ta_cd -- TA代码
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,appl_flow_num -- 申请流水号
    ,seller_id -- 销售商编号
    ,tran_org_id -- 交易机构编号
    ,finc_acct_id -- 理财账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,prod_id -- 产品编号
    ,finc_prod_id -- 理财产品编号
    ,lot_cate_cd -- 份额类别代码
    ,appl_amt -- 申请金额
    ,appl_shares -- 申请份数
    ,init_appl_flow_num -- 原申请流水号
    ,init_cfm_flow_num -- 原确认流水号
    ,divd_way_cd -- 分红方式代码
    ,ta_init_flg -- TA发起标志
    ,ext_bus_cd -- 外部业务代码
    ,ta_manu_check_flg -- TA人工审核标志
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,cfm_dt -- 确认日期
    ,status_cd -- 状态代码
    ,cfm_amt -- 确认金额
    ,tran_chn_cd -- 交易渠道代码
    ,bank_id -- 银行编号
    ,redem_mode_cd -- 赎回模式代码
    ,return_info -- 返回信息
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
    ,o.bus_cd -- 业务代码
    ,o.ta_cd -- TA代码
    ,o.appl_dt -- 申请日期
    ,o.appl_tm -- 申请时间
    ,o.appl_flow_num -- 申请流水号
    ,o.seller_id -- 销售商编号
    ,o.tran_org_id -- 交易机构编号
    ,o.finc_acct_id -- 理财账户编号
    ,o.ta_tran_acct_id -- TA交易账户编号
    ,o.prod_id -- 产品编号
    ,o.finc_prod_id -- 理财产品编号
    ,o.lot_cate_cd -- 份额类别代码
    ,o.appl_amt -- 申请金额
    ,o.appl_shares -- 申请份数
    ,o.init_appl_flow_num -- 原申请流水号
    ,o.init_cfm_flow_num -- 原确认流水号
    ,o.divd_way_cd -- 分红方式代码
    ,o.ta_init_flg -- TA发起标志
    ,o.ext_bus_cd -- 外部业务代码
    ,o.ta_manu_check_flg -- TA人工审核标志
    ,o.cust_type_cd -- 客户类型代码
    ,o.finc_cust_id -- 理财客户编号
    ,o.cfm_dt -- 确认日期
    ,o.status_cd -- 状态代码
    ,o.cfm_amt -- 确认金额
    ,o.tran_chn_cd -- 交易渠道代码
    ,o.bank_id -- 银行编号
    ,o.redem_mode_cd -- 赎回模式代码
    ,o.return_info -- 返回信息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_bk o
    left join ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_cl d
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
--truncate table ${iml_schema}.evt_distr_finc_tran_req_h;
alter table ${iml_schema}.evt_distr_finc_tran_req_h truncate partition for ('ifdsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_distr_finc_tran_req_h exchange subpartition p_ifdsf1_19000101 with table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_cl;
alter table ${iml_schema}.evt_distr_finc_tran_req_h exchange subpartition p_ifdsf1_20991231 with table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_distr_finc_tran_req_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_tm purge;
drop table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_op purge;
drop table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_distr_finc_tran_req_h_ifdsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_distr_finc_tran_req_h', partname => 'p_ifdsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
