/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bond_prft_risk_estim_dtl_ctmsi1
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
drop table ${iml_schema}.evt_bond_prft_risk_estim_dtl_ctmsi1_tm purge;
alter table ${iml_schema}.evt_bond_prft_risk_estim_dtl add partition p_ctmsi1 values ('ctmsi1')(
        subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bond_prft_risk_estim_dtl modify partition p_ctmsi1
    add subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bond_prft_risk_estim_dtl_ctmsi1_tm
compress ${option_switch} for query high
as
select
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,src_bond_id -- 源债券编号
    ,bond_name -- 债券名称
    ,bond_cate_cd -- 债券类别代码
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,estim_dt -- 评估日期
    ,curr_cd -- 币种代码
    ,bond_fac_val -- 债券面值
    ,market_net_price -- 市场净价
    ,market_net_price_src_descb -- 市场净价来源描述
    ,net_price_mk_val -- 净价市值
    ,market_full_price -- 市场全价
    ,full_price_mk_val -- 全价市值
    ,cvty -- 凸性
    ,duran -- 久期
    ,coret_duran -- 修正久期
    ,pvbp -- pvbp
    ,pend_tenor -- 待偿期限
    ,var_val -- var值
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bond_prft_risk_estim_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ctms_tbs_vi_security_profit_loss
insert into ${iml_schema}.evt_bond_prft_risk_estim_dtl_ctmsi1_tm(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,src_bond_id -- 源债券编号
    ,bond_name -- 债券名称
    ,bond_cate_cd -- 债券类别代码
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,estim_dt -- 评估日期
    ,curr_cd -- 币种代码
    ,bond_fac_val -- 债券面值
    ,market_net_price -- 市场净价
    ,market_net_price_src_descb -- 市场净价来源描述
    ,net_price_mk_val -- 净价市值
    ,market_full_price -- 市场全价
    ,full_price_mk_val -- 全价市值
    ,cvty -- 凸性
    ,duran -- 久期
    ,coret_duran -- 修正久期
    ,pvbp -- pvbp
    ,pend_tenor -- 待偿期限
    ,var_val -- var值
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p1.SECURITY_ID||p1.SECURITY_TYPE||p1.KEEPFOLDER_ID -- 债券编号
    ,'9999' -- 法人编号
    ,p1.SECURITY_ID -- 源债券编号
    ,p1.SECURITY_NAME -- 债券名称
    ,nvl(trim(p1.SECURITY_TYPE),'S') -- 债券类别代码
    ,to_char(p1.KEEPFOLDER_ID) -- 账簿编号
    ,p1.KEEPFOLDER_NAME -- 账簿名称
    ,${iml_schema}.dateformat_min(p1.SETTLEDATE) -- 评估日期
    ,nvl(trim(p1.CURRENCY),'-') -- 币种代码
    ,p1.LAST_QTY -- 债券面值
    ,p1.CDC_PRICE -- 市场净价
    ,p1.MARKET_PRICE_TYPE -- 市场净价来源描述
    ,p1.MARKET_VALUE -- 净价市值
    ,p1.DIRTY_PRICE -- 市场全价
    ,p1.DIRTY_MARKET_VALUE -- 全价市值
    ,p1.CONVEXITY -- 凸性
    ,p1.DURATION -- 久期
    ,p1.M_DURATION -- 修正久期
    ,p1.PVBP -- pvbp
    ,p1.TERM_TO_MATURITY -- 待偿期限
    ,p1.VAR -- var值
    ,p1.LAST_MODIFIED -- 最后修改时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vi_security_profit_loss' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vi_security_profit_loss p1
where  1 = 1 
    and p1.settledate = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_bond_prft_risk_estim_dtl truncate subpartition p_ctmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_bond_prft_risk_estim_dtl exchange subpartition p_ctmsi1_${batch_date} with table ${iml_schema}.evt_bond_prft_risk_estim_dtl_ctmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bond_prft_risk_estim_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_bond_prft_risk_estim_dtl_ctmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bond_prft_risk_estim_dtl', partname => 'p_ctmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);