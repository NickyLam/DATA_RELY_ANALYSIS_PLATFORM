/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_agt_cust_acct_sub_acct_rela_h
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--营运管驾Itl层存放历史数据
alter table ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt -- 数据日期
    ,agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_rela_type_cd -- 协议关系类型代码
    ,seq_num -- 序号
    ,rela_agt_id -- 关联协议编号
    ,acct_id -- 账户编号
    ,acct_sub_acct_id -- 账户分户编号
    ,stand_b_type_cd -- 台账类型代码
    ,dep_basic_acct_flg -- 存款基本户标志
    ,curr_cd -- 币种代码
    ,ec_flg -- 钞汇标志
    ,ext_prod_id -- 外部产品编号
    ,intnal_prod_id -- 内部产品编号
    ,start_dt -- 开始日期
    ,end_dt -- 结束日期
    ,id_mark -- 删除标识
    ,etl_timestamp -- ETL处理时间
    ,job_cd --任务编码
)
select
    nvl(etl_dt, to_date('00010101', 'yyyymmdd')) as etl_dt -- 数据日期
    ,nvl(trim(agt_id), ' ') as agt_id -- 协议编号
    ,nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(agt_rela_type_cd), ' ') as agt_rela_type_cd -- 协议关系类型代码
    ,nvl(trim(seq_num), ' ') as seq_num -- 序号
    ,nvl(trim(rela_agt_id), ' ') as rela_agt_id -- 关联协议编号
    ,nvl(trim(acct_id), ' ') as acct_id -- 账户编号
    ,nvl(trim(acct_sub_acct_id), ' ') as acct_sub_acct_id -- 账户分户编号
    ,nvl(trim(stand_b_type_cd), ' ') as stand_b_type_cd -- 台账类型代码
    ,nvl(trim(dep_basic_acct_flg), ' ') as dep_basic_acct_flg -- 存款基本户标志
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(ec_flg), ' ') as ec_flg -- 钞汇标志
    ,nvl(trim(ext_prod_id), ' ') as ext_prod_id -- 外部产品编号
    ,nvl(trim(intnal_prod_id), ' ') as intnal_prod_id -- 内部产品编号
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始日期
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束日期
    ,nvl(trim(id_mark), ' ') as id_mark -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
    ,nvl(trim(job_cd), ' ') as job_cd --任务编码
from ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_agt_cust_acct_sub_acct_rela_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);