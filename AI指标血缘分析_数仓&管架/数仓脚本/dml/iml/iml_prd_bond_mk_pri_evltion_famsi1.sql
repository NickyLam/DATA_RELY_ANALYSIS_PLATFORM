/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_mk_pri_evltion_famsi1
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
drop table ${iml_schema}.prd_bond_mk_pri_evltion_famsi1_tm purge;
alter table ${iml_schema}.prd_bond_mk_pri_evltion add partition p_famsi1 values ('famsi1')(
        subpartition p_famsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_bond_mk_pri_evltion modify partition p_famsi1
    add subpartition p_famsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_mk_pri_evltion_famsi1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,price_dt -- 价格日期
    ,surp_tenor -- 剩余期限
    ,mk_pri_full_price -- 市价全价
    ,mk_pri_net_price -- 市价净价
    ,mk_pri_duran -- 市价久期
    ,mk_pri_cvty -- 市价凸性
    ,bp_val -- 基点价值
    ,spd_duran -- 利差久期
    ,spd_cvty -- 利差凸性
    ,int_rat_duran -- 利率久期
    ,int_rat_cvty -- 利率凸性
    ,mk_pri_yld_rat -- 市价收益率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_mk_pri_evltion
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fams_src_cbvlt-
insert into ${iml_schema}.prd_bond_mk_pri_evltion_famsi1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,price_dt -- 价格日期
    ,surp_tenor -- 剩余期限
    ,mk_pri_full_price -- 市价全价
    ,mk_pri_net_price -- 市价净价
    ,mk_pri_duran -- 市价久期
    ,mk_pri_cvty -- 市价凸性
    ,bp_val -- 基点价值
    ,spd_duran -- 利差久期
    ,spd_cvty -- 利差凸性
    ,int_rat_duran -- 利率久期
    ,int_rat_cvty -- 利率凸性
    ,mk_pri_yld_rat -- 市价收益率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SECID -- 产品编号
    ,'9999' -- 法人编号
    ,TO_DATE(P1.CDATE,'YYYY/MM/DD') -- 价格日期
    ,P1.ENCASH_YEARS -- 剩余期限
    ,P1.MDPRICE -- 市价全价
    ,P1.MCPRICE -- 市价净价
    ,P1.M_MDURATION -- 市价久期
    ,P1.M_CNVXTY -- 市价凸性
    ,P1.MBASISVALUE -- 基点价值
    ,P1.MSPRD_D -- 利差久期
    ,P1.MSPRD_CNVXTY -- 利差凸性
    ,P1.MYIELD_D -- 利率久期
    ,P1.MYIELD_CNVXTY -- 利率凸性
    ,P1.MYIELD -- 市价收益率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_src_cbvlt' -- 源表名称
    ,'famsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_src_cbvlt p1
where  1 = 1 
    AND P1.ETL_DT=to_date('${batch_date}','yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.prd_bond_mk_pri_evltion truncate subpartition p_famsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.prd_bond_mk_pri_evltion exchange subpartition p_famsi1_${batch_date} with table ${iml_schema}.prd_bond_mk_pri_evltion_famsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond_mk_pri_evltion to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_bond_mk_pri_evltion_famsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond_mk_pri_evltion', partname => 'p_famsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);