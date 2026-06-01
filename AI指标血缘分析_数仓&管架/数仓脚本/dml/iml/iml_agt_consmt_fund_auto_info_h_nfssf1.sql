/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_consmt_fund_auto_info_h_nfssf1
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
alter table ${iml_schema}.agt_consmt_fund_auto_info_h add partition p_nfssf1 values ('nfssf1')(
        subpartition p_nfssf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_nfssf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_consmt_fund_auto_info_h partition for ('nfssf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_tm purge;
drop table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_op purge;
drop table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,auto_finc_id -- 自动理财编号
    ,finc_tran_cd -- 理财交易代码
    ,appl_dt -- 申请日期
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,cust_grouping_cd -- 客户分组代码
    ,open_chn_cd -- 开通渠道代码
    ,tran_org_id -- 交易机构编号
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,invest_amt -- 投资金额
    ,invest_lot -- 投资份额
    ,huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,lowt_invest_amt -- 最低投资金额
    ,higt_invest_amt -- 最高投资金额
    ,resv_amt -- 保留金额
    ,tran_discnt_rat -- 交易折扣率
    ,termnt_mode_cd -- 终止模式代码
    ,invest_day -- 投资日
    ,invest_perds -- 投资期数
    ,surp_invest_perds -- 剩余投资期数
    ,sucs_invest_perds -- 成功投资期数
    ,conti_fail_perds -- 连续失败期数
    ,invest_ped_cd -- 投资周期代码
    ,invest_intrv -- 投资间隔
    ,next_invest_dt -- 下一投资日期
    ,last_invest_dt -- 上一投资日期
    ,latest_tran_comnt -- 最新交易说明
    ,end_flg_cd -- 结束标志代码
    ,start_invest_dt -- 开始投资日期
    ,cust_mgr_id -- 客户经理编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_consmt_fund_auto_info_h partition for ('nfssf1')
where 0=1
;

create table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_consmt_fund_auto_info_h partition for ('nfssf1') where 0=1;

create table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_consmt_fund_auto_info_h partition for ('nfssf1') where 0=1;

-- 3.1 get new data into table
-- nfss_tbautoinvest-
insert into ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,auto_finc_id -- 自动理财编号
    ,finc_tran_cd -- 理财交易代码
    ,appl_dt -- 申请日期
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,cust_grouping_cd -- 客户分组代码
    ,open_chn_cd -- 开通渠道代码
    ,tran_org_id -- 交易机构编号
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,invest_amt -- 投资金额
    ,invest_lot -- 投资份额
    ,huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,lowt_invest_amt -- 最低投资金额
    ,higt_invest_amt -- 最高投资金额
    ,resv_amt -- 保留金额
    ,tran_discnt_rat -- 交易折扣率
    ,termnt_mode_cd -- 终止模式代码
    ,invest_day -- 投资日
    ,invest_perds -- 投资期数
    ,surp_invest_perds -- 剩余投资期数
    ,sucs_invest_perds -- 成功投资期数
    ,conti_fail_perds -- 连续失败期数
    ,invest_ped_cd -- 投资周期代码
    ,invest_intrv -- 投资间隔
    ,next_invest_dt -- 下一投资日期
    ,last_invest_dt -- 上一投资日期
    ,latest_tran_comnt -- 最新交易说明
    ,end_flg_cd -- 结束标志代码
    ,start_invest_dt -- 开始投资日期
    ,cust_mgr_id -- 客户经理编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130020'||p1.SERIAL_NO -- 协议编号
    ,'9999' -- 法人编号
    ,p1.SERIAL_NO -- 自动理财编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| p1.BUSIN_FLAG END -- 理财交易代码
    ,${iml_schema}.DATEFORMAT_MAX(p1.TRANS_DATE) -- 申请日期
    ,p1.IN_CLIENT_NO -- 理财客户编号
    ,p1.BANK_NO -- 银行编号
    ,p1.CLIENT_NO -- 客户编号
    ,p1.BANK_ACC -- 账户编号
    ,NVL(trim(p1.CASH_FLAG),'-') -- 钞汇标识代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||p1.CLIENT_GROUP END -- 客户分组代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||p1.CHANNEL END -- 开通渠道代码
    ,p1.BRANCH_NO -- 交易机构编号
    ,p1.PRD_CODE -- 产品编号
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,p1.AMT -- 投资金额
    ,p1.VOL -- 投资份额
    ,NVL(TRIM(P1.LARG_RED_FLAG),'-') -- 巨额赎回处理标志代码
    ,p1.MIN_AMT -- 最低投资金额
    ,p1.MAX_AMT -- 最高投资金额
    ,p1.HOLD_AMT -- 保留金额
    ,p1.AGIO -- 交易折扣率
    ,nvl(trim(p1.OVER_FLAG),'-') -- 终止模式代码
    ,p1.INVEST_DAY -- 投资日
    ,p1.INVEST_TIMES -- 投资期数
    ,p1.REMAIN_TIMES -- 剩余投资期数
    ,p1.TOT_TIMES -- 成功投资期数
    ,p1.FAIL_TIMES -- 连续失败期数
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||p1.PERIOD END -- 投资周期代码
    ,p1.SPAN -- 投资间隔
    ,${iml_schema}.DATEFORMAT_MAX(p1.NEXT_INVEST_DATE) -- 下一投资日期
    ,${iml_schema}.DATEFORMAT_MAX(p1.LAST_INVEST_DATE) -- 上一投资日期
    ,p1.LAST_MSG -- 最新交易说明
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||p1.FINISH_FLAG END -- 结束标志代码
    ,${iml_schema}.DATEFORMAT_MAX(p1.START_INVEST_DATE) -- 开始投资日期
    ,p1.CLIENT_MANAGER -- 客户经理编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tbautoinvest' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tbautoinvest p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUSIN_FLAG= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_TBAUTOINVEST'
        AND R1.SRC_FIELD_EN_NAME= 'BUSIN_FLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CONSMT_FUND_AUTO_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'FINC_TRAN_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CLIENT_GROUP= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_TBAUTOINVEST'
        AND R2.SRC_FIELD_EN_NAME= 'CLIENT_GROUP'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_CONSMT_FUND_AUTO_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CHANNEL= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TBAUTOINVEST'
        AND R3.SRC_FIELD_EN_NAME= 'CHANNEL'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_CONSMT_FUND_AUTO_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'OPEN_CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.PERIOD= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'NFSS'
        AND R4.SRC_TAB_EN_NAME= 'NFSS_TBAUTOINVEST'
        AND R4.SRC_FIELD_EN_NAME= 'PERIOD'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_CONSMT_FUND_AUTO_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'INVEST_PED_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.FINISH_FLAG= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'NFSS'
        AND R5.SRC_TAB_EN_NAME= 'NFSS_TBAUTOINVEST'
        AND R5.SRC_FIELD_EN_NAME= 'FINISH_FLAG'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_CONSMT_FUND_AUTO_INFO_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'END_FLG_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,auto_finc_id -- 自动理财编号
    ,finc_tran_cd -- 理财交易代码
    ,appl_dt -- 申请日期
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,cust_grouping_cd -- 客户分组代码
    ,open_chn_cd -- 开通渠道代码
    ,tran_org_id -- 交易机构编号
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,invest_amt -- 投资金额
    ,invest_lot -- 投资份额
    ,huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,lowt_invest_amt -- 最低投资金额
    ,higt_invest_amt -- 最高投资金额
    ,resv_amt -- 保留金额
    ,tran_discnt_rat -- 交易折扣率
    ,termnt_mode_cd -- 终止模式代码
    ,invest_day -- 投资日
    ,invest_perds -- 投资期数
    ,surp_invest_perds -- 剩余投资期数
    ,sucs_invest_perds -- 成功投资期数
    ,conti_fail_perds -- 连续失败期数
    ,invest_ped_cd -- 投资周期代码
    ,invest_intrv -- 投资间隔
    ,next_invest_dt -- 下一投资日期
    ,last_invest_dt -- 上一投资日期
    ,latest_tran_comnt -- 最新交易说明
    ,end_flg_cd -- 结束标志代码
    ,start_invest_dt -- 开始投资日期
    ,cust_mgr_id -- 客户经理编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,auto_finc_id -- 自动理财编号
    ,finc_tran_cd -- 理财交易代码
    ,appl_dt -- 申请日期
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,cust_grouping_cd -- 客户分组代码
    ,open_chn_cd -- 开通渠道代码
    ,tran_org_id -- 交易机构编号
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,invest_amt -- 投资金额
    ,invest_lot -- 投资份额
    ,huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,lowt_invest_amt -- 最低投资金额
    ,higt_invest_amt -- 最高投资金额
    ,resv_amt -- 保留金额
    ,tran_discnt_rat -- 交易折扣率
    ,termnt_mode_cd -- 终止模式代码
    ,invest_day -- 投资日
    ,invest_perds -- 投资期数
    ,surp_invest_perds -- 剩余投资期数
    ,sucs_invest_perds -- 成功投资期数
    ,conti_fail_perds -- 连续失败期数
    ,invest_ped_cd -- 投资周期代码
    ,invest_intrv -- 投资间隔
    ,next_invest_dt -- 下一投资日期
    ,last_invest_dt -- 上一投资日期
    ,latest_tran_comnt -- 最新交易说明
    ,end_flg_cd -- 结束标志代码
    ,start_invest_dt -- 开始投资日期
    ,cust_mgr_id -- 客户经理编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.auto_finc_id, o.auto_finc_id) as auto_finc_id -- 自动理财编号
    ,nvl(n.finc_tran_cd, o.finc_tran_cd) as finc_tran_cd -- 理财交易代码
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.finc_cust_id, o.finc_cust_id) as finc_cust_id -- 理财客户编号
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.ec_idf_cd, o.ec_idf_cd) as ec_idf_cd -- 钞汇标识代码
    ,nvl(n.cust_grouping_cd, o.cust_grouping_cd) as cust_grouping_cd -- 客户分组代码
    ,nvl(n.open_chn_cd, o.open_chn_cd) as open_chn_cd -- 开通渠道代码
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.invest_amt, o.invest_amt) as invest_amt -- 投资金额
    ,nvl(n.invest_lot, o.invest_lot) as invest_lot -- 投资份额
    ,nvl(n.huge_redem_proc_flg_cd, o.huge_redem_proc_flg_cd) as huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,nvl(n.lowt_invest_amt, o.lowt_invest_amt) as lowt_invest_amt -- 最低投资金额
    ,nvl(n.higt_invest_amt, o.higt_invest_amt) as higt_invest_amt -- 最高投资金额
    ,nvl(n.resv_amt, o.resv_amt) as resv_amt -- 保留金额
    ,nvl(n.tran_discnt_rat, o.tran_discnt_rat) as tran_discnt_rat -- 交易折扣率
    ,nvl(n.termnt_mode_cd, o.termnt_mode_cd) as termnt_mode_cd -- 终止模式代码
    ,nvl(n.invest_day, o.invest_day) as invest_day -- 投资日
    ,nvl(n.invest_perds, o.invest_perds) as invest_perds -- 投资期数
    ,nvl(n.surp_invest_perds, o.surp_invest_perds) as surp_invest_perds -- 剩余投资期数
    ,nvl(n.sucs_invest_perds, o.sucs_invest_perds) as sucs_invest_perds -- 成功投资期数
    ,nvl(n.conti_fail_perds, o.conti_fail_perds) as conti_fail_perds -- 连续失败期数
    ,nvl(n.invest_ped_cd, o.invest_ped_cd) as invest_ped_cd -- 投资周期代码
    ,nvl(n.invest_intrv, o.invest_intrv) as invest_intrv -- 投资间隔
    ,nvl(n.next_invest_dt, o.next_invest_dt) as next_invest_dt -- 下一投资日期
    ,nvl(n.last_invest_dt, o.last_invest_dt) as last_invest_dt -- 上一投资日期
    ,nvl(n.latest_tran_comnt, o.latest_tran_comnt) as latest_tran_comnt -- 最新交易说明
    ,nvl(n.end_flg_cd, o.end_flg_cd) as end_flg_cd -- 结束标志代码
    ,nvl(n.start_invest_dt, o.start_invest_dt) as start_invest_dt -- 开始投资日期
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_tm n
    full join (select * from ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.auto_finc_id <> n.auto_finc_id
        or o.finc_tran_cd <> n.finc_tran_cd
        or o.appl_dt <> n.appl_dt
        or o.finc_cust_id <> n.finc_cust_id
        or o.bank_id <> n.bank_id
        or o.cust_id <> n.cust_id
        or o.acct_id <> n.acct_id
        or o.ec_idf_cd <> n.ec_idf_cd
        or o.cust_grouping_cd <> n.cust_grouping_cd
        or o.open_chn_cd <> n.open_chn_cd
        or o.tran_org_id <> n.tran_org_id
        or o.prod_id <> n.prod_id
        or o.ta_cd <> n.ta_cd
        or o.invest_amt <> n.invest_amt
        or o.invest_lot <> n.invest_lot
        or o.huge_redem_proc_flg_cd <> n.huge_redem_proc_flg_cd
        or o.lowt_invest_amt <> n.lowt_invest_amt
        or o.higt_invest_amt <> n.higt_invest_amt
        or o.resv_amt <> n.resv_amt
        or o.tran_discnt_rat <> n.tran_discnt_rat
        or o.termnt_mode_cd <> n.termnt_mode_cd
        or o.invest_day <> n.invest_day
        or o.invest_perds <> n.invest_perds
        or o.surp_invest_perds <> n.surp_invest_perds
        or o.sucs_invest_perds <> n.sucs_invest_perds
        or o.conti_fail_perds <> n.conti_fail_perds
        or o.invest_ped_cd <> n.invest_ped_cd
        or o.invest_intrv <> n.invest_intrv
        or o.next_invest_dt <> n.next_invest_dt
        or o.last_invest_dt <> n.last_invest_dt
        or o.latest_tran_comnt <> n.latest_tran_comnt
        or o.end_flg_cd <> n.end_flg_cd
        or o.start_invest_dt <> n.start_invest_dt
        or o.cust_mgr_id <> n.cust_mgr_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,auto_finc_id -- 自动理财编号
    ,finc_tran_cd -- 理财交易代码
    ,appl_dt -- 申请日期
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,cust_grouping_cd -- 客户分组代码
    ,open_chn_cd -- 开通渠道代码
    ,tran_org_id -- 交易机构编号
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,invest_amt -- 投资金额
    ,invest_lot -- 投资份额
    ,huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,lowt_invest_amt -- 最低投资金额
    ,higt_invest_amt -- 最高投资金额
    ,resv_amt -- 保留金额
    ,tran_discnt_rat -- 交易折扣率
    ,termnt_mode_cd -- 终止模式代码
    ,invest_day -- 投资日
    ,invest_perds -- 投资期数
    ,surp_invest_perds -- 剩余投资期数
    ,sucs_invest_perds -- 成功投资期数
    ,conti_fail_perds -- 连续失败期数
    ,invest_ped_cd -- 投资周期代码
    ,invest_intrv -- 投资间隔
    ,next_invest_dt -- 下一投资日期
    ,last_invest_dt -- 上一投资日期
    ,latest_tran_comnt -- 最新交易说明
    ,end_flg_cd -- 结束标志代码
    ,start_invest_dt -- 开始投资日期
    ,cust_mgr_id -- 客户经理编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,auto_finc_id -- 自动理财编号
    ,finc_tran_cd -- 理财交易代码
    ,appl_dt -- 申请日期
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,cust_grouping_cd -- 客户分组代码
    ,open_chn_cd -- 开通渠道代码
    ,tran_org_id -- 交易机构编号
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,invest_amt -- 投资金额
    ,invest_lot -- 投资份额
    ,huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,lowt_invest_amt -- 最低投资金额
    ,higt_invest_amt -- 最高投资金额
    ,resv_amt -- 保留金额
    ,tran_discnt_rat -- 交易折扣率
    ,termnt_mode_cd -- 终止模式代码
    ,invest_day -- 投资日
    ,invest_perds -- 投资期数
    ,surp_invest_perds -- 剩余投资期数
    ,sucs_invest_perds -- 成功投资期数
    ,conti_fail_perds -- 连续失败期数
    ,invest_ped_cd -- 投资周期代码
    ,invest_intrv -- 投资间隔
    ,next_invest_dt -- 下一投资日期
    ,last_invest_dt -- 上一投资日期
    ,latest_tran_comnt -- 最新交易说明
    ,end_flg_cd -- 结束标志代码
    ,start_invest_dt -- 开始投资日期
    ,cust_mgr_id -- 客户经理编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.auto_finc_id -- 自动理财编号
    ,o.finc_tran_cd -- 理财交易代码
    ,o.appl_dt -- 申请日期
    ,o.finc_cust_id -- 理财客户编号
    ,o.bank_id -- 银行编号
    ,o.cust_id -- 客户编号
    ,o.acct_id -- 账户编号
    ,o.ec_idf_cd -- 钞汇标识代码
    ,o.cust_grouping_cd -- 客户分组代码
    ,o.open_chn_cd -- 开通渠道代码
    ,o.tran_org_id -- 交易机构编号
    ,o.prod_id -- 产品编号
    ,o.ta_cd -- TA代码
    ,o.invest_amt -- 投资金额
    ,o.invest_lot -- 投资份额
    ,o.huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,o.lowt_invest_amt -- 最低投资金额
    ,o.higt_invest_amt -- 最高投资金额
    ,o.resv_amt -- 保留金额
    ,o.tran_discnt_rat -- 交易折扣率
    ,o.termnt_mode_cd -- 终止模式代码
    ,o.invest_day -- 投资日
    ,o.invest_perds -- 投资期数
    ,o.surp_invest_perds -- 剩余投资期数
    ,o.sucs_invest_perds -- 成功投资期数
    ,o.conti_fail_perds -- 连续失败期数
    ,o.invest_ped_cd -- 投资周期代码
    ,o.invest_intrv -- 投资间隔
    ,o.next_invest_dt -- 下一投资日期
    ,o.last_invest_dt -- 上一投资日期
    ,o.latest_tran_comnt -- 最新交易说明
    ,o.end_flg_cd -- 结束标志代码
    ,o.start_invest_dt -- 开始投资日期
    ,o.cust_mgr_id -- 客户经理编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_bk o
    left join ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_consmt_fund_auto_info_h;
alter table ${iml_schema}.agt_consmt_fund_auto_info_h truncate partition for ('nfssf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_consmt_fund_auto_info_h exchange subpartition p_nfssf1_19000101 with table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_cl;
alter table ${iml_schema}.agt_consmt_fund_auto_info_h exchange subpartition p_nfssf1_20991231 with table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_consmt_fund_auto_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_tm purge;
drop table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_op purge;
drop table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_consmt_fund_auto_info_h_nfssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_consmt_fund_auto_info_h', partname => 'p_nfssf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
