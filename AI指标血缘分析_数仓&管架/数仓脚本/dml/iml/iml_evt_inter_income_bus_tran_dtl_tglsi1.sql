/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_inter_income_bus_tran_dtl_tglsi1
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
drop table ${iml_schema}.evt_inter_income_bus_tran_dtl_tglsi1_tm purge;
alter table ${iml_schema}.evt_inter_income_bus_tran_dtl add partition p_tglsi1 values ('tglsi1')(
        subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_inter_income_bus_tran_dtl modify partition p_tglsi1
    add subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_inter_income_bus_tran_dtl_tglsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 业务系统编号
    ,fin_dt -- 财务日期
    ,doc_id -- 单据编号
    ,tran_flow_num -- 交易流水号
    ,new_tran_flow_num -- 新交易流水号
    ,ova_flow_num -- 全局流水号
    ,tran_tm -- 交易时间
    ,proc_status_cd -- 处理状态代码
    ,fee_cd -- 费用代码
    ,prod_id -- 产品编号
    ,fin_org_id -- 财务机构编号
    ,curr_cd -- 币种代码
    ,tran_chn_id -- 交易渠道编号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_code -- 交易码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,batch_no -- 批次号
    ,seq_num -- 序号
    ,bus_type_cd -- 业务类型代码
    ,tran_type_cd -- 交易类型代码
    ,update_bus_flow_num -- 更新业务流水号
    ,sellbl_prod_id -- 可售产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_inter_income_bus_tran_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- tgls_ami_mdsr_tran_h-1
insert into ${iml_schema}.evt_inter_income_bus_tran_dtl_tglsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 业务系统编号
    ,fin_dt -- 财务日期
    ,doc_id -- 单据编号
    ,tran_flow_num -- 交易流水号
    ,new_tran_flow_num -- 新交易流水号
    ,ova_flow_num -- 全局流水号
    ,tran_tm -- 交易时间
    ,proc_status_cd -- 处理状态代码
    ,fee_cd -- 费用代码
    ,prod_id -- 产品编号
    ,fin_org_id -- 财务机构编号
    ,curr_cd -- 币种代码
    ,tran_chn_id -- 交易渠道编号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_code -- 交易码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,batch_no -- 批次号
    ,seq_num -- 序号
    ,bus_type_cd -- 业务类型代码
    ,tran_type_cd -- 交易类型代码
    ,update_bus_flow_num -- 更新业务流水号
    ,sellbl_prod_id -- 可售产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '302002'||P1.TRANSQ||P1.EVENSQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.STACID -- 账套编号
    ,P1.SYSTID -- 业务系统编号
    ,${iml_schema}.dateformat_min(P1.DATADT) -- 财务日期
    ,P1.LOANNO -- 单据编号
    ,P1.TRANSQ -- 交易流水号
    ,P1.NETRSQ -- 新交易流水号
    ,P1.BSNSSQ --全局流水号
    ,P1.TRANTI -- 交易时间
    ,NVL(trim(P1.DEALTG),'-') -- 处理状态代码
    ,P1.PRDUCD -- 费用代码
    ,P1.PRODP1 -- 产品编号
    ,P1.DEPTCD -- 财务机构编号
    ,P1.CRCYCD -- 币种代码
    ,P1.ATTRA1 -- 交易渠道编号
    ,${iml_schema}.dateformat_min(P1.TRANDT) -- 交易日期
    ,P1.TRANBR -- 交易机构编号
    ,P1.EVENCD -- 交易码
    ,${iml_schema}.dateformat_min(P1.AMOTRBDT) -- 摊销开始日期
    ,${iml_schema}.dateformat_max2(P1.AMOTRODT) -- 摊销结束日期
    ,P1.NORMPR -- 待摊总金额
    ,P1.AMOU01 -- 本次摊销金额
    ,P1.BATHID -- 批次号
    ,to_char(P1.EVENSQ) -- 序号
    ,P1.BUSITP -- 业务类型代码
    ,P1.EVENTP -- 交易类型代码
    ,P1.ATTRA4 -- 更新业务流水号
    ,P1.ATTRA5 -- 可售产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_ami_mdsr_tran_h' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_ami_mdsr_tran_h p1
where  1 = 1 
    and P1.DATADT=${batch_date}
;
commit;

-- tgls_ami_mdsr_tran-1
insert into ${iml_schema}.evt_inter_income_bus_tran_dtl_tglsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 业务系统编号
    ,fin_dt -- 财务日期
    ,doc_id -- 单据编号
    ,tran_flow_num -- 交易流水号
    ,new_tran_flow_num -- 新交易流水号
    ,ova_flow_num -- 全局流水号
    ,tran_tm -- 交易时间
    ,proc_status_cd -- 处理状态代码
    ,fee_cd -- 费用代码
    ,prod_id -- 产品编号
    ,fin_org_id -- 财务机构编号
    ,curr_cd -- 币种代码
    ,tran_chn_id -- 交易渠道编号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_code -- 交易码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,batch_no -- 批次号
    ,seq_num -- 序号
    ,bus_type_cd -- 业务类型代码
    ,tran_type_cd -- 交易类型代码
    ,update_bus_flow_num -- 更新业务流水号
    ,sellbl_prod_id -- 可售产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '302002'||P1.TRANSQ||P1.EVENSQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.STACID -- 账套编号
    ,P1.SYSTID -- 业务系统编号
    ,${iml_schema}.dateformat_min(P1.DATADT) -- 财务日期
    ,P1.LOANNO -- 单据编号
    ,P1.TRANSQ -- 交易流水号
    ,P1.NETRSQ -- 新交易流水号
    ,P1.BSNSSQ -- 全局流水号
    ,P1.TRANTI -- 交易时间
    ,NVL(trim(P1.DEALTG),'-') -- 处理状态代码
    ,P1.PRDUCD -- 费用代码
    ,P1.PRODP1 -- 产品编号
    ,P1.DEPTCD -- 财务机构编号
    ,P1.CRCYCD -- 币种代码
    ,P1.ATTRA1 -- 交易渠道编号
    ,${iml_schema}.dateformat_min(P1.TRANDT) -- 交易日期
    ,P1.TRANBR -- 交易机构编号
    ,P1.EVENCD -- 交易码
    ,${iml_schema}.dateformat_min(P1.AMOTRBDT) -- 摊销开始日期
    ,${iml_schema}.dateformat_max2(P1.AMOTRODT) -- 摊销结束日期
    ,P1.NORMPR -- 待摊总金额
    ,P1.AMOU01 -- 本次摊销金额
    ,P1.BATHID -- 批次号
    ,to_char(P1.EVENSQ) -- 序号
    ,nvl(trim(P1.BUSITP),'-') -- 业务类型代码
    ,nvl(trim(P1.EVENTP),'-') -- 交易类型代码
    ,P1.ATTRA4 -- 更新业务流水号
    ,P1.ATTRA5 -- 可售产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_ami_mdsr_tran' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_ami_mdsr_tran p1
where  1 = 1 
     and not exists (select * from iol.tgls_ami_mdsr_tran_h p2 where   p1.stacid  = p2.stacid
and p1.systid  = p2.systid
and p1.datadt  = p2.datadt
and p1.bathid  = p2.bathid
and p1.loanno  = p2.loanno
and p1.transq  = p2.transq
and p1.evensq  = p2.evensq)
and P1.DATADT=${batch_date}
;
commit;





-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_inter_income_bus_tran_dtl truncate subpartition p_tglsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_inter_income_bus_tran_dtl exchange subpartition p_tglsi1_${batch_date} with table ${iml_schema}.evt_inter_income_bus_tran_dtl_tglsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_inter_income_bus_tran_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_inter_income_bus_tran_dtl_tglsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_inter_income_bus_tran_dtl', partname => 'p_tglsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);