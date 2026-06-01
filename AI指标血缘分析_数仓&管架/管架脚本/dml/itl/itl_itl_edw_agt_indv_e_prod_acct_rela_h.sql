/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_agt_indv_e_prod_acct_rela_h
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
alter table ${itl_schema}.itl_edw_agt_indv_e_prod_acct_rela_h drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_agt_indv_e_prod_acct_rela_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_agt_indv_e_prod_acct_rela_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_agt_indv_e_prod_acct_rela_h partition for (to_date('${batch_date}','yyyymmdd')) (
    acct_rela_id -- 账户关系编号
    ,prod_acct_id -- 产品账户编号
    ,party_id -- 当事人编号
    ,agt_id -- 协议编号
    ,e_acct_id -- E账户编号
    ,acct_sub_seq_num -- 账户子序号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,mercht_id -- 商户编号
    ,fea_name_cd -- 特征名称代码
    ,prod_id -- 产品编号
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,med_type_cd -- 介质类型代码
    ,start_dt -- 开始日期
    ,end_dt -- 结束日期
    ,id_mark -- 删除标识
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(acct_rela_id), ' ') as acct_rela_id -- 账户关系编号
    ,nvl(trim(prod_acct_id), ' ') as prod_acct_id -- 产品账户编号
    ,nvl(trim(party_id), ' ') as party_id -- 当事人编号
    ,nvl(trim(agt_id), ' ') as agt_id -- 协议编号
    ,nvl(trim(e_acct_id), ' ') as e_acct_id -- E账户编号
    ,nvl(trim(acct_sub_seq_num), ' ') as acct_sub_seq_num -- 账户子序号
    ,nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(acct_id), ' ') as acct_id -- 账户编号
    ,nvl(trim(mercht_id), ' ') as mercht_id -- 商户编号
    ,nvl(trim(fea_name_cd), ' ') as fea_name_cd -- 特征名称代码
    ,nvl(trim(prod_id), ' ') as prod_id -- 产品编号
    ,nvl(effect_tm, to_timestamp('00010101', 'yyyymmdd')) as effect_tm -- 生效时间
    ,nvl(invalid_tm, to_timestamp('00010101', 'yyyymmdd')) as invalid_tm -- 失效时间
    ,nvl(trim(med_type_cd), ' ') as med_type_cd -- 介质类型代码
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始日期
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束日期
    ,nvl(trim(id_mark), ' ') as id_mark -- 删除标识
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_agt_indv_e_prod_acct_rela_h
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_agt_indv_e_prod_acct_rela_h to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_agt_indv_e_prod_acct_rela_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);