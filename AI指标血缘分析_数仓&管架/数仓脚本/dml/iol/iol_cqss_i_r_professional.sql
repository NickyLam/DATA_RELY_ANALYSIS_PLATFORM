/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_i_r_professional
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cqss_i_r_professional_ex purge;
alter table ${iol_schema}.cqss_i_r_professional add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_i_r_professional truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_i_r_professional_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_i_r_professional where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_i_r_professional_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,pbc_cr_emp_sttn -- 人行征信就业状况:PB040D01
    ,wrk_unit_nm -- 工作单位名称:PB040Q01
    ,pbc_cr_unit_char -- 人行征信单位性质:PB040D02
    ,idy_cd -- 行业代码:PB040D03
    ,cr_rsdnc_adr -- 征信居住地址:PB040Q02
    ,move_telno -- 移动电话号码:PB040Q03
    ,pbc_cr_ocp -- 人行征信职业:PB040D04
    ,pbc_cr_post -- 人行征信职务:PB040D05
    ,pbc_cr_ttl -- 人行征信职称:PB040D06
    ,entr_crnco_wkdy_prd -- 进入现单位工作日期:PB040R01
    ,cr_inf_udt_dt -- 征信信息更新日期:PB040R02
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间:
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,pbc_cr_emp_sttn -- 人行征信就业状况:PB040D01
    ,wrk_unit_nm -- 工作单位名称:PB040Q01
    ,pbc_cr_unit_char -- 人行征信单位性质:PB040D02
    ,idy_cd -- 行业代码:PB040D03
    ,cr_rsdnc_adr -- 征信居住地址:PB040Q02
    ,move_telno -- 移动电话号码:PB040Q03
    ,pbc_cr_ocp -- 人行征信职业:PB040D04
    ,pbc_cr_post -- 人行征信职务:PB040D05
    ,pbc_cr_ttl -- 人行征信职称:PB040D06
    ,entr_crnco_wkdy_prd -- 进入现单位工作日期:PB040R01
    ,cr_inf_udt_dt -- 征信信息更新日期:PB040R02
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间:
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_i_r_professional
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_i_r_professional exchange partition p_${batch_date} with table ${iol_schema}.cqss_i_r_professional_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_i_r_professional to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_i_r_professional_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_i_r_professional',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);