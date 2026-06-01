/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_direct_mch_pos
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
create table ${iol_schema}.amss_cms_direct_mch_pos_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_direct_mch_pos
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_direct_mch_pos_op purge;
drop table ${iol_schema}.amss_cms_direct_mch_pos_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_direct_mch_pos_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_direct_mch_pos where 0=1;

create table ${iol_schema}.amss_cms_direct_mch_pos_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_direct_mch_pos where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_direct_mch_pos_cl(
            id -- 
            ,term_no -- 终端号
            ,js_no -- 机身号
            ,term_type -- 终端类型：00-POS、01-MIS、15-智能POS、18-mPOS、19-人脸识别终端、22-行业终端、23-非接扫码枪终端、24-非接扫码盒终端、25-手机POS终端
            ,use_city -- 使用地域，城市编码
            ,term_sn -- 终端序列号/SN号
            ,product_no -- 产品型号
            ,producer -- 生产商
            ,term_address -- 终端地址
            ,term_status -- 终端状态：1-启用，2-冻结，3-注销
            ,term_secret -- 终端密钥
            ,union_partner -- 银联商户号
            ,mch_no -- 商户号
            ,mch_nm -- 商户名称
            ,channel_id -- 绑定机构号
            ,aff_channel -- 所属机构号
            ,channel_nm -- 绑定机构名称
            ,physics_flag -- 
            ,create_time -- 
            ,create_user -- 
            ,create_emp -- 
            ,update_user -- 
            ,update_time -- 
            ,update_emp -- 
            ,use_region_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_direct_mch_pos_op(
            id -- 
            ,term_no -- 终端号
            ,js_no -- 机身号
            ,term_type -- 终端类型：00-POS、01-MIS、15-智能POS、18-mPOS、19-人脸识别终端、22-行业终端、23-非接扫码枪终端、24-非接扫码盒终端、25-手机POS终端
            ,use_city -- 使用地域，城市编码
            ,term_sn -- 终端序列号/SN号
            ,product_no -- 产品型号
            ,producer -- 生产商
            ,term_address -- 终端地址
            ,term_status -- 终端状态：1-启用，2-冻结，3-注销
            ,term_secret -- 终端密钥
            ,union_partner -- 银联商户号
            ,mch_no -- 商户号
            ,mch_nm -- 商户名称
            ,channel_id -- 绑定机构号
            ,aff_channel -- 所属机构号
            ,channel_nm -- 绑定机构名称
            ,physics_flag -- 
            ,create_time -- 
            ,create_user -- 
            ,create_emp -- 
            ,update_user -- 
            ,update_time -- 
            ,update_emp -- 
            ,use_region_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.term_no, o.term_no) as term_no -- 终端号
    ,nvl(n.js_no, o.js_no) as js_no -- 机身号
    ,nvl(n.term_type, o.term_type) as term_type -- 终端类型：00-POS、01-MIS、15-智能POS、18-mPOS、19-人脸识别终端、22-行业终端、23-非接扫码枪终端、24-非接扫码盒终端、25-手机POS终端
    ,nvl(n.use_city, o.use_city) as use_city -- 使用地域，城市编码
    ,nvl(n.term_sn, o.term_sn) as term_sn -- 终端序列号/SN号
    ,nvl(n.product_no, o.product_no) as product_no -- 产品型号
    ,nvl(n.producer, o.producer) as producer -- 生产商
    ,nvl(n.term_address, o.term_address) as term_address -- 终端地址
    ,nvl(n.term_status, o.term_status) as term_status -- 终端状态：1-启用，2-冻结，3-注销
    ,nvl(n.term_secret, o.term_secret) as term_secret -- 终端密钥
    ,nvl(n.union_partner, o.union_partner) as union_partner -- 银联商户号
    ,nvl(n.mch_no, o.mch_no) as mch_no -- 商户号
    ,nvl(n.mch_nm, o.mch_nm) as mch_nm -- 商户名称
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 绑定机构号
    ,nvl(n.aff_channel, o.aff_channel) as aff_channel -- 所属机构号
    ,nvl(n.channel_nm, o.channel_nm) as channel_nm -- 绑定机构名称
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.create_user, o.create_user) as create_user -- 
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 
    ,nvl(n.update_user, o.update_user) as update_user -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 
    ,nvl(n.use_region_code, o.use_region_code) as use_region_code -- 
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
from (select * from ${iol_schema}.amss_cms_direct_mch_pos_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_direct_mch_pos where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.term_no <> n.term_no
        or o.js_no <> n.js_no
        or o.term_type <> n.term_type
        or o.use_city <> n.use_city
        or o.term_sn <> n.term_sn
        or o.product_no <> n.product_no
        or o.producer <> n.producer
        or o.term_address <> n.term_address
        or o.term_status <> n.term_status
        or o.term_secret <> n.term_secret
        or o.union_partner <> n.union_partner
        or o.mch_no <> n.mch_no
        or o.mch_nm <> n.mch_nm
        or o.channel_id <> n.channel_id
        or o.aff_channel <> n.aff_channel
        or o.channel_nm <> n.channel_nm
        or o.physics_flag <> n.physics_flag
        or o.create_time <> n.create_time
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.update_emp <> n.update_emp
        or o.use_region_code <> n.use_region_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_direct_mch_pos_cl(
            id -- 
            ,term_no -- 终端号
            ,js_no -- 机身号
            ,term_type -- 终端类型：00-POS、01-MIS、15-智能POS、18-mPOS、19-人脸识别终端、22-行业终端、23-非接扫码枪终端、24-非接扫码盒终端、25-手机POS终端
            ,use_city -- 使用地域，城市编码
            ,term_sn -- 终端序列号/SN号
            ,product_no -- 产品型号
            ,producer -- 生产商
            ,term_address -- 终端地址
            ,term_status -- 终端状态：1-启用，2-冻结，3-注销
            ,term_secret -- 终端密钥
            ,union_partner -- 银联商户号
            ,mch_no -- 商户号
            ,mch_nm -- 商户名称
            ,channel_id -- 绑定机构号
            ,aff_channel -- 所属机构号
            ,channel_nm -- 绑定机构名称
            ,physics_flag -- 
            ,create_time -- 
            ,create_user -- 
            ,create_emp -- 
            ,update_user -- 
            ,update_time -- 
            ,update_emp -- 
            ,use_region_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_direct_mch_pos_op(
            id -- 
            ,term_no -- 终端号
            ,js_no -- 机身号
            ,term_type -- 终端类型：00-POS、01-MIS、15-智能POS、18-mPOS、19-人脸识别终端、22-行业终端、23-非接扫码枪终端、24-非接扫码盒终端、25-手机POS终端
            ,use_city -- 使用地域，城市编码
            ,term_sn -- 终端序列号/SN号
            ,product_no -- 产品型号
            ,producer -- 生产商
            ,term_address -- 终端地址
            ,term_status -- 终端状态：1-启用，2-冻结，3-注销
            ,term_secret -- 终端密钥
            ,union_partner -- 银联商户号
            ,mch_no -- 商户号
            ,mch_nm -- 商户名称
            ,channel_id -- 绑定机构号
            ,aff_channel -- 所属机构号
            ,channel_nm -- 绑定机构名称
            ,physics_flag -- 
            ,create_time -- 
            ,create_user -- 
            ,create_emp -- 
            ,update_user -- 
            ,update_time -- 
            ,update_emp -- 
            ,use_region_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.term_no -- 终端号
    ,o.js_no -- 机身号
    ,o.term_type -- 终端类型：00-POS、01-MIS、15-智能POS、18-mPOS、19-人脸识别终端、22-行业终端、23-非接扫码枪终端、24-非接扫码盒终端、25-手机POS终端
    ,o.use_city -- 使用地域，城市编码
    ,o.term_sn -- 终端序列号/SN号
    ,o.product_no -- 产品型号
    ,o.producer -- 生产商
    ,o.term_address -- 终端地址
    ,o.term_status -- 终端状态：1-启用，2-冻结，3-注销
    ,o.term_secret -- 终端密钥
    ,o.union_partner -- 银联商户号
    ,o.mch_no -- 商户号
    ,o.mch_nm -- 商户名称
    ,o.channel_id -- 绑定机构号
    ,o.aff_channel -- 所属机构号
    ,o.channel_nm -- 绑定机构名称
    ,o.physics_flag -- 
    ,o.create_time -- 
    ,o.create_user -- 
    ,o.create_emp -- 
    ,o.update_user -- 
    ,o.update_time -- 
    ,o.update_emp -- 
    ,o.use_region_code -- 
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
from ${iol_schema}.amss_cms_direct_mch_pos_bk o
    left join ${iol_schema}.amss_cms_direct_mch_pos_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_direct_mch_pos_cl d
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
--truncate table ${iol_schema}.amss_cms_direct_mch_pos;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_direct_mch_pos') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_direct_mch_pos drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_direct_mch_pos add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_direct_mch_pos exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_direct_mch_pos_cl;
alter table ${iol_schema}.amss_cms_direct_mch_pos exchange partition p_20991231 with table ${iol_schema}.amss_cms_direct_mch_pos_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_direct_mch_pos to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_direct_mch_pos_op purge;
drop table ${iol_schema}.amss_cms_direct_mch_pos_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_direct_mch_pos_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_direct_mch_pos',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
