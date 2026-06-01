/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_htes_ptcpt_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.bdms_htes_ptcpt_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_htes_ptcpt_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_htes_ptcpt_info_op purge;
drop table ${iol_schema}.bdms_htes_ptcpt_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_htes_ptcpt_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_htes_ptcpt_info where 0=1;

create table ${iol_schema}.bdms_htes_ptcpt_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_htes_ptcpt_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_htes_ptcpt_info_cl(
            id -- ID
            ,bank_no -- 参与机构行号
            ,actor_type -- 参与机构类别： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
            ,bank_other_code -- 行别代码
            ,belong_bank_no -- 所属直参行号
            ,belong_legal_no -- 所属法人
            ,up_actor_no -- 本行上级参与机构
            ,recept_bank_no -- 承接行行号
            ,cate_people_code -- 管辖人行行号
            ,ccpc_code -- 所属CCPC
            ,city_code -- 所在城市代码
            ,bank_name -- 参与机构全称
            ,tel_phone -- 电话或电挂
            ,jion_flag -- 加入人行大额业务系统标识
            ,effect_type -- 生效类型： EF00 立即生效 EF01 指定日期生效
            ,effect_date -- 生效日期
            ,expire_date -- 失效日期
            ,cert_status -- 证书绑定状态： 00 未绑定 01 已绑定
            ,refer_code -- 参考码
            ,auth_code -- 授权码
            ,last_upd_time -- 最后修改时间
            ,last_upd_opr -- 最后操作员
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_htes_ptcpt_info_op(
            id -- ID
            ,bank_no -- 参与机构行号
            ,actor_type -- 参与机构类别： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
            ,bank_other_code -- 行别代码
            ,belong_bank_no -- 所属直参行号
            ,belong_legal_no -- 所属法人
            ,up_actor_no -- 本行上级参与机构
            ,recept_bank_no -- 承接行行号
            ,cate_people_code -- 管辖人行行号
            ,ccpc_code -- 所属CCPC
            ,city_code -- 所在城市代码
            ,bank_name -- 参与机构全称
            ,tel_phone -- 电话或电挂
            ,jion_flag -- 加入人行大额业务系统标识
            ,effect_type -- 生效类型： EF00 立即生效 EF01 指定日期生效
            ,effect_date -- 生效日期
            ,expire_date -- 失效日期
            ,cert_status -- 证书绑定状态： 00 未绑定 01 已绑定
            ,refer_code -- 参考码
            ,auth_code -- 授权码
            ,last_upd_time -- 最后修改时间
            ,last_upd_opr -- 最后操作员
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 参与机构行号
    ,nvl(n.actor_type, o.actor_type) as actor_type -- 参与机构类别： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
    ,nvl(n.bank_other_code, o.bank_other_code) as bank_other_code -- 行别代码
    ,nvl(n.belong_bank_no, o.belong_bank_no) as belong_bank_no -- 所属直参行号
    ,nvl(n.belong_legal_no, o.belong_legal_no) as belong_legal_no -- 所属法人
    ,nvl(n.up_actor_no, o.up_actor_no) as up_actor_no -- 本行上级参与机构
    ,nvl(n.recept_bank_no, o.recept_bank_no) as recept_bank_no -- 承接行行号
    ,nvl(n.cate_people_code, o.cate_people_code) as cate_people_code -- 管辖人行行号
    ,nvl(n.ccpc_code, o.ccpc_code) as ccpc_code -- 所属CCPC
    ,nvl(n.city_code, o.city_code) as city_code -- 所在城市代码
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 参与机构全称
    ,nvl(n.tel_phone, o.tel_phone) as tel_phone -- 电话或电挂
    ,nvl(n.jion_flag, o.jion_flag) as jion_flag -- 加入人行大额业务系统标识
    ,nvl(n.effect_type, o.effect_type) as effect_type -- 生效类型： EF00 立即生效 EF01 指定日期生效
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 生效日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 失效日期
    ,nvl(n.cert_status, o.cert_status) as cert_status -- 证书绑定状态： 00 未绑定 01 已绑定
    ,nvl(n.refer_code, o.refer_code) as refer_code -- 参考码
    ,nvl(n.auth_code, o.auth_code) as auth_code -- 授权码
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_htes_ptcpt_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_htes_ptcpt_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.bank_no <> n.bank_no
        or o.actor_type <> n.actor_type
        or o.bank_other_code <> n.bank_other_code
        or o.belong_bank_no <> n.belong_bank_no
        or o.belong_legal_no <> n.belong_legal_no
        or o.up_actor_no <> n.up_actor_no
        or o.recept_bank_no <> n.recept_bank_no
        or o.cate_people_code <> n.cate_people_code
        or o.ccpc_code <> n.ccpc_code
        or o.city_code <> n.city_code
        or o.bank_name <> n.bank_name
        or o.tel_phone <> n.tel_phone
        or o.jion_flag <> n.jion_flag
        or o.effect_type <> n.effect_type
        or o.effect_date <> n.effect_date
        or o.expire_date <> n.expire_date
        or o.cert_status <> n.cert_status
        or o.refer_code <> n.refer_code
        or o.auth_code <> n.auth_code
        or o.last_upd_time <> n.last_upd_time
        or o.last_upd_opr <> n.last_upd_opr
        or o.create_by <> n.create_by
        or o.create_time <> n.create_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_htes_ptcpt_info_cl(
            id -- ID
            ,bank_no -- 参与机构行号
            ,actor_type -- 参与机构类别： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
            ,bank_other_code -- 行别代码
            ,belong_bank_no -- 所属直参行号
            ,belong_legal_no -- 所属法人
            ,up_actor_no -- 本行上级参与机构
            ,recept_bank_no -- 承接行行号
            ,cate_people_code -- 管辖人行行号
            ,ccpc_code -- 所属CCPC
            ,city_code -- 所在城市代码
            ,bank_name -- 参与机构全称
            ,tel_phone -- 电话或电挂
            ,jion_flag -- 加入人行大额业务系统标识
            ,effect_type -- 生效类型： EF00 立即生效 EF01 指定日期生效
            ,effect_date -- 生效日期
            ,expire_date -- 失效日期
            ,cert_status -- 证书绑定状态： 00 未绑定 01 已绑定
            ,refer_code -- 参考码
            ,auth_code -- 授权码
            ,last_upd_time -- 最后修改时间
            ,last_upd_opr -- 最后操作员
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_htes_ptcpt_info_op(
            id -- ID
            ,bank_no -- 参与机构行号
            ,actor_type -- 参与机构类别： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
            ,bank_other_code -- 行别代码
            ,belong_bank_no -- 所属直参行号
            ,belong_legal_no -- 所属法人
            ,up_actor_no -- 本行上级参与机构
            ,recept_bank_no -- 承接行行号
            ,cate_people_code -- 管辖人行行号
            ,ccpc_code -- 所属CCPC
            ,city_code -- 所在城市代码
            ,bank_name -- 参与机构全称
            ,tel_phone -- 电话或电挂
            ,jion_flag -- 加入人行大额业务系统标识
            ,effect_type -- 生效类型： EF00 立即生效 EF01 指定日期生效
            ,effect_date -- 生效日期
            ,expire_date -- 失效日期
            ,cert_status -- 证书绑定状态： 00 未绑定 01 已绑定
            ,refer_code -- 参考码
            ,auth_code -- 授权码
            ,last_upd_time -- 最后修改时间
            ,last_upd_opr -- 最后操作员
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.bank_no -- 参与机构行号
    ,o.actor_type -- 参与机构类别： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
    ,o.bank_other_code -- 行别代码
    ,o.belong_bank_no -- 所属直参行号
    ,o.belong_legal_no -- 所属法人
    ,o.up_actor_no -- 本行上级参与机构
    ,o.recept_bank_no -- 承接行行号
    ,o.cate_people_code -- 管辖人行行号
    ,o.ccpc_code -- 所属CCPC
    ,o.city_code -- 所在城市代码
    ,o.bank_name -- 参与机构全称
    ,o.tel_phone -- 电话或电挂
    ,o.jion_flag -- 加入人行大额业务系统标识
    ,o.effect_type -- 生效类型： EF00 立即生效 EF01 指定日期生效
    ,o.effect_date -- 生效日期
    ,o.expire_date -- 失效日期
    ,o.cert_status -- 证书绑定状态： 00 未绑定 01 已绑定
    ,o.refer_code -- 参考码
    ,o.auth_code -- 授权码
    ,o.last_upd_time -- 最后修改时间
    ,o.last_upd_opr -- 最后操作员
    ,o.create_by -- 创建人
    ,o.create_time -- 创建时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_htes_ptcpt_info_bk o
    left join ${iol_schema}.bdms_htes_ptcpt_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_htes_ptcpt_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_htes_ptcpt_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_htes_ptcpt_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_htes_ptcpt_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_htes_ptcpt_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_htes_ptcpt_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_htes_ptcpt_info_cl;
alter table ${iol_schema}.bdms_htes_ptcpt_info exchange partition p_20991231 with table ${iol_schema}.bdms_htes_ptcpt_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_htes_ptcpt_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_htes_ptcpt_info_op purge;
drop table ${iol_schema}.bdms_htes_ptcpt_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_htes_ptcpt_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_htes_ptcpt_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
