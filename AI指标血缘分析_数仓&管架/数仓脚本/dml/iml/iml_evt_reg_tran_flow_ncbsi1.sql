/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_reg_tran_flow_ncbsi1
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
drop table ${iml_schema}.evt_reg_tran_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_reg_tran_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_reg_tran_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_reg_tran_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    acct_id -- 账户编号
    ,evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,time_dep_rcpt_num -- 定期存单号
    ,revs_tran_seq_num -- 冲正交易序号
    ,tran_seq_num -- 交易序号
    ,cust_id -- 客户编号
    ,acct_base_int_rat -- 账户基础利率
    ,acct_open_acct_dt -- 账户开户日期
    ,tran_dt -- 交易日期
    ,acct_exp_dt -- 账户到期日期
    ,vouch_type_cd -- 凭证类型代码
    ,loss_id -- 挂失编号
    ,tran_ref_no -- 交易参考号
    ,redt_seq_num -- 转存序号
    ,tax -- 税金
    ,wdraw_amt -- 支取金额
    ,tran_happ_pric -- 交易发生本金
    ,actl_pric_amt -- 实际本金金额
    ,tot_int_amt -- 总利息金额
    ,int_adj_add_amt -- 利息调增金额
    ,provi_day_int_adj -- 计提日利息调整
    ,net_int -- 净利息
    ,float_point -- 浮动点数
    ,wdraw_int_rat -- 支取利率
    ,tenor_type_cd -- 期限类型代码
    ,exp_advise_flg -- 到期通知标志
    ,advise_dep_tenor -- 通知存款期限
    ,pric_int_redt_cnt -- 本息转存次数
    ,deduct_type_cd -- 扣划类型代码
    ,tran_scene_descb -- 交易场景描述
    ,conti_dep_term_cnt -- 续存期数
    ,allow_add_pric_flg -- 允许增加本金标志
    ,redt_way_type_cd -- 转存方式类型代码
    ,dep_term_tenor -- 存期期限
    ,redt_type_cd -- 转存类型代码
    ,part_pric_redt_flg -- 部分本金转存标志
    ,pric_redt_cnt -- 本金转存次数
    ,tran_valid_flg -- 交易有效标志
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_reg_tran_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ncbs_rb_tda_hist-1
insert into ${iml_schema}.evt_reg_tran_flow_ncbsi1_tm(
    acct_id -- 账户编号
    ,evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,time_dep_rcpt_num -- 定期存单号
    ,revs_tran_seq_num -- 冲正交易序号
    ,tran_seq_num -- 交易序号
    ,cust_id -- 客户编号
    ,acct_base_int_rat -- 账户基础利率
    ,acct_open_acct_dt -- 账户开户日期
    ,tran_dt -- 交易日期
    ,acct_exp_dt -- 账户到期日期
    ,vouch_type_cd -- 凭证类型代码
    ,loss_id -- 挂失编号
    ,tran_ref_no -- 交易参考号
    ,redt_seq_num -- 转存序号
    ,tax -- 税金
    ,wdraw_amt -- 支取金额
    ,tran_happ_pric -- 交易发生本金
    ,actl_pric_amt -- 实际本金金额
    ,tot_int_amt -- 总利息金额
    ,int_adj_add_amt -- 利息调增金额
    ,provi_day_int_adj -- 计提日利息调整
    ,net_int -- 净利息
    ,float_point -- 浮动点数
    ,wdraw_int_rat -- 支取利率
    ,tenor_type_cd -- 期限类型代码
    ,exp_advise_flg -- 到期通知标志
    ,advise_dep_tenor -- 通知存款期限
    ,pric_int_redt_cnt -- 本息转存次数
    ,deduct_type_cd -- 扣划类型代码
    ,tran_scene_descb -- 交易场景描述
    ,conti_dep_term_cnt -- 续存期数
    ,allow_add_pric_flg -- 允许增加本金标志
    ,redt_way_type_cd -- 转存方式类型代码
    ,dep_term_tenor -- 存期期限
    ,redt_type_cd -- 转存类型代码
    ,part_pric_redt_flg -- 部分本金转存标志
    ,pric_redt_cnt -- 本金转存次数
    ,tran_valid_flg -- 交易有效标志
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.INTERNAL_KEY -- 账户编号
    ,'101064'||P1.SEQ_NO -- 事件编号
    ,P1.SEQ_NO -- 交易流水号
    ,'9999' -- 法人编号
    ,P1.TDA_CERTIFICATE_NO -- 定期存单号
    ,P1.REV_SEQ_NO -- 冲正交易序号
    ,P1.TRAN_SEQ_NO -- 交易序号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.ACCT_LEVEL_INT_RATE -- 账户基础利率
    ,P1.ACCT_OPEN_DATE -- 账户开户日期
    ,P1.ACCT_MOVT_DATE -- 交易日期
    ,P1.MATURITY_DATE -- 账户到期日期
    ,nvl(trim(P1.DOC_TYPE),'-') -- 凭证类型代码
    ,P1.LOST_NO -- 挂失编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.SEQ_RENEW_ROLLOVER_NO -- 转存序号
    ,P1.TAX_AMT -- 税金
    ,P1.DEBT_AMT -- 支取金额
    ,P1.PRINCIPAL_AMT -- 交易发生本金
    ,P1.PRINCIPAL_AMT_ACTUAL -- 实际本金金额
    ,P1.GROSS_INTEREST_AMT -- 总利息金额
    ,P1.INT_ADJ -- 利息调增金额
    ,P1.INT_ADJ_CTD -- 计提日利息调整
    ,P1.NET_INTEREST_AMT -- 净利息
    ,P1.SPREAD_RATE -- 浮动点数
    ,P1.DEBT_INT_RATE -- 支取利率
    ,nvl(trim(P1.DEP_TERM_TYPE),'-') -- 期限类型代码
    ,DECODE(TRIM(P1.MAT_NOTICE_FLAG),'','-','Y','1','N','0',P1.MAT_NOTICE_FLAG) -- 到期通知标志
    ,NVL(TRIM(P1.NOTICE_PERIOD),0) -- 通知存款期限
    ,P1.ROLLOVER_NO -- 本息转存次数
    ,nvl(trim(P1.IMPOUND_TYPE),'-') -- 扣划类型代码
    ,P1.TRAN_SCENE -- 交易场景描述
    ,P1.ADD_TERM -- 续存期数
    ,DECODE(TRIM(P1.ADDTL_PRINCIPAL),'','-','Y','1','N','0',P1.ADDTL_PRINCIPAL) -- 允许增加本金标志
    ,nvl(trim(P1.AUTO_RENEW_ROLLOVER),'-') -- 转存方式类型代码
    ,NVL(TRIM(P1.DEP_TERM_PERIOD),0) -- 存期期限
    ,nvl(trim(P1.MOVT_STATUS),'-') -- 转存类型代码
    ,DECODE(TRIM(P1.PARTIAL_RENEW_ROLL),'','-','Y','1','N','0',P1.PARTIAL_RENEW_ROLL) -- 部分本金转存标志
    ,P1.RENEW_NO -- 本金转存次数
    ,DECODE(TRIM(P1.TDA_STATUS),'','-','Y','1','N','0',P1.TDA_STATUS) -- 交易有效标志
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.USER_ID -- 交易柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_tda_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_tda_hist p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_reg_tran_flow truncate partition p_ncbsi1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_reg_tran_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_reg_tran_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_reg_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_reg_tran_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_reg_tran_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);