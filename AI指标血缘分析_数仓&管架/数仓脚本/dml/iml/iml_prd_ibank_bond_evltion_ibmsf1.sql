/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ibank_bond_evltion_ibmsf1
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
drop table ${iml_schema}.prd_ibank_bond_evltion_ibmsf1_tm purge;
alter table ${iml_schema}.prd_ibank_bond_evltion add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_ibank_bond_evltion modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_bond_evltion_ibmsf1_tm
compress ${option_switch} for query high
as
select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,net_price_amt -- 净价金额
    ,acru_int -- 应计利息
    ,estim_yld_rat -- 估价收益率
    ,spread_yld_rat -- 点差收益率
    ,estim_pend_ped -- 估价待偿期
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,estim_bp_val -- 估价基点价值
    ,estim_spd_duran -- 估价利差久期
    ,estim_spd_cvty -- 估价利差凸性
    ,estim_int_rat_duran -- 估价利率久期
    ,estim_int_rat_cvty -- 估价利率凸性
    ,full_price_amt -- 全价金额
    ,input_dt -- 录入日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_bond_evltion
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ibms_tcb_bond_eval-
insert into ${iml_schema}.prd_ibank_bond_evltion_ibmsf1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,net_price_amt -- 净价金额
    ,acru_int -- 应计利息
    ,estim_yld_rat -- 估价收益率
    ,spread_yld_rat -- 点差收益率
    ,estim_pend_ped -- 估价待偿期
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,estim_bp_val -- 估价基点价值
    ,estim_spd_duran -- 估价利差久期
    ,estim_spd_cvty -- 估价利差凸性
    ,estim_int_rat_duran -- 估价利率久期
    ,estim_int_rat_cvty -- 估价利率凸性
    ,full_price_amt -- 全价金额
    ,input_dt -- 录入日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    , '9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.BEG_DATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.END_DATE) -- 失效日期
    ,P1.NETPRICE -- 净价金额
    ,P1.AI -- 应计利息
    ,P1.YIELD -- 估价收益率
    ,P1.RD_YIELD -- 点差收益率
    ,P1.TERM -- 估价待偿期
    ,P1.MODIFIED_D -- 估价修正久期
    ,P1.CONVEXITY -- 估价凸性
    ,P1.DVBP -- 估价基点价值
    ,P1.RD_MODIFIED -- 估价利差久期
    ,P1.RD_CONVEXITY -- 估价利差凸性
    ,P1.R_MODIFIED -- 估价利率久期
    ,P1.R_CONVEXITY -- 估价利率凸性
    ,P1.FULLPRICE -- 全价金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.IMP_DATE) -- 录入日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_tcb_bond_eval' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_tcb_bond_eval p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.prd_ibank_bond_evltion truncate partition p_ibmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.prd_ibank_bond_evltion exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_ibank_bond_evltion_ibmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ibank_bond_evltion to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_ibank_bond_evltion_ibmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ibank_bond_evltion', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);