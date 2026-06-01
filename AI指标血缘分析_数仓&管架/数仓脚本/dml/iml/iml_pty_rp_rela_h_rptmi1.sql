/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_rp_rela_h_rptmi1
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
drop table ${iml_schema}.pty_rp_rela_h_rptmi1_tm purge;
alter table ${iml_schema}.pty_rp_rela_h add partition p_rptmi1 values ('rptmi1')(
        subpartition p_rptmi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_rp_rela_h modify partition p_rptmi1
    add subpartition p_rptmi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_rp_rela_h_rptmi1_tm
compress ${option_switch} for query high
as
select
    bus_id -- 业务编号
    ,lp_id -- 法人编号
    ,rela_party_id -- 关联方编号
    ,sys_in_bus_id -- 系统内业务编号
    ,rela_party_type_cd -- 关联方类型代码
    ,this_rela_party_bus_id -- 本层关联方业务编号
    ,super_rela_party_type_cd -- 上级关联方类型代码
    ,super_rela_party_id -- 上级关联方编号
    ,super_rela_party_name -- 上级关联方名称
    ,super_cert_type_cd -- 上级证件类型代码
    ,super_cert_no -- 上级证件号码
    ,and_super_incid_rela_type_cd -- 与上级关联关系类型代码
    ,and_super_eqty_rela_type_cd -- 与上级权益关系类型代码
    ,hold_ratio -- 持有比例
    ,incid_rela_comnt -- 关联关系说明
    ,status_cd -- 关联方有效标志
    ,valid_flg -- 有效标志
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,remit_tm -- 解除时间
    ,remark -- 备注
    ,creator_id -- 创建人编号
    ,create_tm -- 创建时间
    ,create_org_id -- 创建机构编号
    ,create_dept_id -- 创建部门编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_rp_rela_h
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- rptm_rtm_rp_his_relation-1
insert into ${iml_schema}.pty_rp_rela_h_rptmi1_tm(
    bus_id -- 业务编号
    ,lp_id -- 法人编号
    ,rela_party_id -- 关联方编号
    ,sys_in_bus_id -- 系统内业务编号
    ,rela_party_type_cd -- 关联方类型代码
    ,this_rela_party_bus_id -- 本层关联方业务编号
    ,super_rela_party_type_cd -- 上级关联方类型代码
    ,super_rela_party_id -- 上级关联方编号
    ,super_rela_party_name -- 上级关联方名称
    ,super_cert_type_cd -- 上级证件类型代码
    ,super_cert_no -- 上级证件号码
    ,and_super_incid_rela_type_cd -- 与上级关联关系类型代码
    ,and_super_eqty_rela_type_cd -- 与上级权益关系类型代码
    ,hold_ratio -- 持有比例
    ,incid_rela_comnt -- 关联关系说明
    ,status_cd -- 关联方有效标志
    ,valid_flg -- 有效标志
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,remit_tm -- 解除时间
    ,remark -- 备注
    ,creator_id -- 创建人编号
    ,create_tm -- 创建时间
    ,create_org_id -- 创建机构编号
    ,create_dept_id -- 创建部门编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p1.id -- 业务编号
    ,'9999' -- 法人编号
    ,p1.bus_id -- 关联方编号
    ,p1.his_bus_id -- 系统内业务编号
    ,nvl(trim(p1.entity_rp_type),'-') -- 关联方类型代码
    ,p1.entity_bus_id -- 本层关联方业务编号
    ,nvl(trim(p1.super_rp_type),'-') -- 上级关联方类型代码
    ,p1.super_bus_id -- 上级关联方编号
    ,p1.super_rp_name -- 上级关联方名称
    ,nvl(trim(p1.super_ybj_card_type),'0000') -- 上级证件类型代码
    ,p1.super_card_no -- 上级证件号码
    ,nvl(trim(p1.relation_type),'-') -- 与上级关联关系类型代码
    ,nvl(trim(p1.is_share_holding),'-') -- 与上级权益关系类型代码
    ,p1.holding_pct -- 持有比例
    ,p1.relation_info -- 关联关系说明
    ,decode(p1.data_state,'1','1','3','0',' ','-'，p1.data_state) -- 关联方有效标志
    ,nvl(trim(p1.valid_state),'-') -- 有效标志
    ,p1.active_time -- 生效时间
    ,p1.invalid_time -- 失效时间
    ,p1.release_time -- 解除时间
    ,p1.remarks -- 备注
    ,p1.create_user -- 创建人编号
    ,p1.create_time -- 创建时间
    ,p1.create_org -- 创建机构编号
    ,p1.create_dep -- 创建部门编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rptm_rtm_rp_his_relation' -- 源表名称
    ,'rptmi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rptm_rtm_rp_his_relation p1
where  1 = 1 
  and p1.etl_dt = to_date ('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.pty_rp_rela_h truncate subpartition p_rptmi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.pty_rp_rela_h exchange subpartition p_rptmi1_${batch_date} with table ${iml_schema}.pty_rp_rela_h_rptmi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_rp_rela_h to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_rp_rela_h_rptmi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_rp_rela_h', partname => 'p_rptmi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);