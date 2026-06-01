/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_inter_income_sub_acct_bal_dtl_tglsi1
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
drop table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl_tglsi1_tm purge;
alter table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl add partition p_tglsi1 values ('tglsi1')(
        subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl modify partition p_tglsi1
    add subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl_tglsi1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 业务系统编号
    ,fin_dt -- 财务日期
    ,tran_flow_num -- 交易流水号
    ,doc_id -- 单据编号
    ,ova_flow_num -- 全局流水号
    ,prod_id -- 产品编号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,actl_amort_start_dt -- 实际摊销开始日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,acm_amort_amt -- 累计摊销金额
    ,inter_income_amort_status_cd -- 中收摊销状态代码
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,surp_amort_amt -- 剩余摊销金额
    ,amort_days -- 摊销天数
    ,amort_freq_cd -- 摊销频度代码
    ,ths_tm_amort_amt_a_calc_idf_cd -- 本次摊销金额重新计算标识代码
    ,bus_type_cd -- 业务类型代码
    ,tran_type_cd -- 交易类型代码
    ,sub_tran_type_cd -- 子交易类型代码
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,charge_way_cd -- 收费方式代码
    ,batch_no -- 批次号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,measure_post_seq_num -- 计量后_序号
    ,measure_post_fee -- 计量后_费用
    ,measure_post_fee_inco -- 计量后_费用收入
    ,measure_post_revs_flg_cd -- 计量后_冲正标志代码
    ,measure_post_addit_attr_5 -- 计量后_附加属性5
    ,prod_attr_comnt_1 -- 产品属性说明1
    ,addit_attr_comnt_1 -- 附加属性说明1
    ,sub_acct_bal_chg_comnt -- 分户余额变动说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_inter_income_sub_acct_bal_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- tgls_ama_mdsr_acch_h-1
insert into ${iml_schema}.agt_inter_income_sub_acct_bal_dtl_tglsi1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 业务系统编号
    ,fin_dt -- 财务日期
    ,tran_flow_num -- 交易流水号
    ,doc_id -- 单据编号
    ,ova_flow_num -- 全局流水号
    ,prod_id -- 产品编号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,actl_amort_start_dt -- 实际摊销开始日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,acm_amort_amt -- 累计摊销金额
    ,inter_income_amort_status_cd -- 中收摊销状态代码
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,surp_amort_amt -- 剩余摊销金额
    ,amort_days -- 摊销天数
    ,amort_freq_cd -- 摊销频度代码
    ,ths_tm_amort_amt_a_calc_idf_cd -- 本次摊销金额重新计算标识代码
    ,bus_type_cd -- 业务类型代码
    ,tran_type_cd -- 交易类型代码
    ,sub_tran_type_cd -- 子交易类型代码
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,charge_way_cd -- 收费方式代码
    ,batch_no -- 批次号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,measure_post_seq_num -- 计量后_序号
    ,measure_post_fee -- 计量后_费用
    ,measure_post_fee_inco -- 计量后_费用收入
    ,measure_post_revs_flg_cd -- 计量后_冲正标志代码
    ,measure_post_addit_attr_5 -- 计量后_附加属性5
    ,prod_attr_comnt_1 -- 产品属性说明1
    ,addit_attr_comnt_1 -- 附加属性说明1
    ,sub_acct_bal_chg_comnt -- 分户余额变动说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300019'||P1.LOANNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.STACID -- 账套编号
    ,P1.SYSTID -- 业务系统编号
    ,${iml_schema}.dateformat_min(P1.DATADT) -- 财务日期
    ,P1.TRANSQ -- 交易流水号
    ,P1.LOANNO -- 单据编号
    ,P1.BSNSSQ -- 全局流水号
    ,P1.PRDUCD -- 产品编号
    ,P1.DEPTCD -- 账务机构编号
    ,P1.CRCYCD -- 币种代码
    ,${iml_schema}.dateformat_min(P1.AMOTRBDT) -- 摊销开始日期
    ,${iml_schema}.dateformat_max2(P1.AMOTRODT) -- 摊销结束日期
    ,${iml_schema}.dateformat_min(P1.ACAMOTRBDT) -- 实际摊销开始日期
    ,P1.NORMPR -- 待摊总金额
    ,P1.AMORTAM -- 本次摊销金额
    ,P1.AMORTISEDAM -- 累计摊销金额
    ,P1.AMORTST -- 中收摊销状态代码
    ,P1.PRODP1 -- 备注1
    ,P1.ATTRA1 -- 备注2
    ,P1.AMORTAMREDU -- 剩余摊销金额
    ,P1.DAYNUM -- 摊销天数
    ,nvl(trim(P1.AMORFR),'-') -- 摊销频度代码
    ,nvl(trim(P1.CHANGST),'-') -- 本次摊销金额重新计算标识代码
    ,nvl(trim(P1.BUSITP),'-') -- 业务类型代码
    ,nvl(trim(P1.EVENTP),'-') -- 交易类型代码
    ,nvl(trim(P1.TRANCD),'-') -- 子交易类型代码
    ,${iml_schema}.dateformat_max2(P1.TRANDT) -- 交易日期
    ,P1.TRANBR -- 交易机构编号
    ,nvl(trim(P1.CHRGMD),'-') -- 收费方式代码
    ,P1.BATHID -- 批次号
    ,to_char(P1.SORTNO) -- 序号
    ,P1.CUSTCD -- 客户编号
    ,P1.ATTRA8 -- 计量后_序号
    ,P1.AMOU01 -- 计量后_费用
    ,P1.AMOU02 -- 计量后_费用收入
    ,nvl(trim(P1.ATTRA3),'-') -- 计量后_冲正标志代码
    ,P1.ATTRA5 -- 计量后_附加属性5
    ,P1.PRODP1 -- 产品属性说明1
    ,P1.ATTRA1 -- 附加属性说明1
    ,P1.DESCCG -- 分户余额变动说明
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_ama_mdsr_acch_h' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.tgls_ama_mdsr_acch_h p1
 where  1 = 1 
   and p1.datadt = ${batch_date}
   and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- tgls_ama_mdsr_acch-1
insert into ${iml_schema}.agt_inter_income_sub_acct_bal_dtl_tglsi1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 业务系统编号
    ,fin_dt -- 财务日期
    ,tran_flow_num -- 交易流水号
    ,doc_id -- 单据编号
    ,ova_flow_num -- 全局流水号
    ,prod_id -- 产品编号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,actl_amort_start_dt -- 实际摊销开始日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,acm_amort_amt -- 累计摊销金额
    ,inter_income_amort_status_cd -- 中收摊销状态代码
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,surp_amort_amt -- 剩余摊销金额
    ,amort_days -- 摊销天数
    ,amort_freq_cd -- 摊销频度代码
    ,ths_tm_amort_amt_a_calc_idf_cd -- 本次摊销金额重新计算标识代码
    ,bus_type_cd -- 业务类型代码
    ,tran_type_cd -- 交易类型代码
    ,sub_tran_type_cd -- 子交易类型代码
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,charge_way_cd -- 收费方式代码
    ,batch_no -- 批次号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,measure_post_seq_num -- 计量后_序号
    ,measure_post_fee -- 计量后_费用
    ,measure_post_fee_inco -- 计量后_费用收入
    ,measure_post_revs_flg_cd -- 计量后_冲正标志代码
    ,measure_post_addit_attr_5 -- 计量后_附加属性5
    ,prod_attr_comnt_1 -- 产品属性说明1
    ,addit_attr_comnt_1 -- 附加属性说明1
    ,sub_acct_bal_chg_comnt -- 分户余额变动说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300019'||P1.LOANNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.STACID -- 账套编号
    ,P1.SYSTID -- 业务系统编号
    ,${iml_schema}.dateformat_min(P1.DATADT) -- 财务日期
    ,P1.TRANSQ -- 交易流水号
    ,P1.LOANNO -- 单据编号
    ,P1.BSNSSQ -- 全局流水号
    ,P1.PRDUCD -- 产品编号
    ,P1.DEPTCD -- 账务机构编号
    ,P1.CRCYCD -- 币种代码
    ,${iml_schema}.dateformat_min(P1.AMOTRBDT) -- 摊销开始日期
    ,${iml_schema}.dateformat_max2(P1.AMOTRODT) -- 摊销结束日期
    ,${iml_schema}.dateformat_min(P1.ACAMOTRBDT) -- 实际摊销开始日期
    ,P1.NORMPR -- 待摊总金额
    ,P1.AMORTAM -- 本次摊销金额
    ,P1.AMORTISEDAM -- 累计摊销金额
    ,P1.AMORTST -- 中收摊销状态代码
    ,P1.PRODP1 -- 备注1
    ,P1.ATTRA1 -- 备注2
    ,P1.AMORTAMREDU -- 剩余摊销金额
    ,P1.DAYNUM -- 摊销天数
    ,nvl(trim(P1.AMORFR),'-') -- 摊销频度代码
    ,nvl(trim(P1.CHANGST),'-') -- 本次摊销金额重新计算标识代码
    ,nvl(trim(P1.BUSITP),'-') -- 业务类型代码
    ,nvl(trim(P1.EVENTP),'-') -- 交易类型代码
    ,nvl(trim(P1.TRANCD),'-') -- 子交易类型代码
    ,${iml_schema}.dateformat_max2(P1.TRANDT) -- 交易日期
    ,P1.TRANBR -- 交易机构编号
    ,nvl(trim(P1.CHRGMD),'-') -- 收费方式代码
    ,P1.BATHID -- 批次号
    ,to_char(P1.SORTNO) -- 序号
    ,P1.CUSTCD -- 客户编号
    ,P1.ATTRA8 -- 计量后_序号
    ,P1.AMOU01 -- 计量后_费用
    ,P1.AMOU02 -- 计量后_费用收入
    ,nvl(trim(P1.ATTRA3),'-') -- 计量后_冲正标志代码
    ,P1.ATTRA5 -- 计量后_附加属性5
    ,P1.PRODP1 -- 产品属性说明1
    ,P1.ATTRA1 -- 附加属性说明1
    ,P1.DESCCG -- 分户余额变动说明
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_ama_mdsr_acch' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.tgls_ama_mdsr_acch p1
 where not exists (select *
                     from iol.tgls_ama_mdsr_acch_h p2
                    where p1.stacid = p2.stacid
                      and p1.systid = p2.systid
                      and p1.datadt = p2.datadt
                      and p1.transq = p2.transq
                      and p1.trancd = p2.trancd
                      and p1.loanno = p2.loanno
                      and p2.datadt = ${batch_date}
                      and p2.etl_dt = to_date('${batch_date}','yyyymmdd')) 
   and p1.datadt = ${batch_date}
   and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
  ;
commit;





-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl truncate subpartition p_tglsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl exchange subpartition p_tglsi1_${batch_date} with table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl_tglsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_inter_income_sub_acct_bal_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl_tglsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_inter_income_sub_acct_bal_dtl', partname => 'p_tglsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);