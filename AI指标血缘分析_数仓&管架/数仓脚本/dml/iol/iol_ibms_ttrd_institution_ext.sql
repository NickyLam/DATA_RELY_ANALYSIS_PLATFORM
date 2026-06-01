/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_institution_ext
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
create table ${iol_schema}.ibms_ttrd_institution_ext_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_institution_ext
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_institution_ext_op purge;
drop table ${iol_schema}.ibms_ttrd_institution_ext_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_institution_ext_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_institution_ext where 0=1;

create table ${iol_schema}.ibms_ttrd_institution_ext_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_institution_ext where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_institution_ext_cl(
            i_id -- 主键
            ,h_datefield -- 日期类型
            ,h_textfield -- 文本类型
            ,h_numberfield -- 数值类型
            ,h_combobox -- 下拉框类型
            ,h_textarea -- 文本域类型
            ,hx_industy -- 最终投向行业-大类
            ,hx_industy_detail -- 最终投向行业-细类
            ,rh_custeconomypart -- 客户国民经济部门
            ,rh_businesstype -- 所属行业
            ,rh_isrelevancy -- 是否关联方
            ,rh_code -- 代码
            ,rh_institutioncode -- 金融机构编码
            ,rh_depositaccount -- 基本存款账户
            ,rh_economicsector -- 经济成分
            ,rh_bankname -- 基本账户开户行名称
            ,rh_regist -- 注册地址
            ,rh_innerrate -- 内部评级
            ,rh_firmsize -- 企业规模
            ,rh_begindate -- 成立日期
            ,rh_registcode -- 注册地行政区划码
            ,rh_codetype -- 代码类别
            ,rh_custtype -- 客户类别
            ,hx_juridical_p_cert_type -- 法人证件类型
            ,hx_juridical_p_cert_code -- 法人证件号码
            ,hx_pd_of_vali4juridical_p_cert -- 法人证件有效期
            ,funds_prsv -- 资管产品统计编码
            ,prim_org_ptyid -- 主机构客户号
            ,spv_cd -- spv代码
            ,spv_name -- spv名称
            ,spv_type -- spv类型
            ,rh_businesstype_m -- 行业类型,数据标准落标,触发器添加
            ,rh_economicsector_m -- 经济成分,数据标准落标,触发器添加
            ,hx_adminiarea -- 行政区划代码
            ,hx_deteilarea -- 详细地址(不含行政区划)
            ,hx_deteiladdress -- 详细地址(含行政区划)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_institution_ext_op(
            i_id -- 主键
            ,h_datefield -- 日期类型
            ,h_textfield -- 文本类型
            ,h_numberfield -- 数值类型
            ,h_combobox -- 下拉框类型
            ,h_textarea -- 文本域类型
            ,hx_industy -- 最终投向行业-大类
            ,hx_industy_detail -- 最终投向行业-细类
            ,rh_custeconomypart -- 客户国民经济部门
            ,rh_businesstype -- 所属行业
            ,rh_isrelevancy -- 是否关联方
            ,rh_code -- 代码
            ,rh_institutioncode -- 金融机构编码
            ,rh_depositaccount -- 基本存款账户
            ,rh_economicsector -- 经济成分
            ,rh_bankname -- 基本账户开户行名称
            ,rh_regist -- 注册地址
            ,rh_innerrate -- 内部评级
            ,rh_firmsize -- 企业规模
            ,rh_begindate -- 成立日期
            ,rh_registcode -- 注册地行政区划码
            ,rh_codetype -- 代码类别
            ,rh_custtype -- 客户类别
            ,hx_juridical_p_cert_type -- 法人证件类型
            ,hx_juridical_p_cert_code -- 法人证件号码
            ,hx_pd_of_vali4juridical_p_cert -- 法人证件有效期
            ,funds_prsv -- 资管产品统计编码
            ,prim_org_ptyid -- 主机构客户号
            ,spv_cd -- spv代码
            ,spv_name -- spv名称
            ,spv_type -- spv类型
            ,rh_businesstype_m -- 行业类型,数据标准落标,触发器添加
            ,rh_economicsector_m -- 经济成分,数据标准落标,触发器添加
            ,hx_adminiarea -- 行政区划代码
            ,hx_deteilarea -- 详细地址(不含行政区划)
            ,hx_deteiladdress -- 详细地址(含行政区划)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_id, o.i_id) as i_id -- 主键
    ,nvl(n.h_datefield, o.h_datefield) as h_datefield -- 日期类型
    ,nvl(n.h_textfield, o.h_textfield) as h_textfield -- 文本类型
    ,nvl(n.h_numberfield, o.h_numberfield) as h_numberfield -- 数值类型
    ,nvl(n.h_combobox, o.h_combobox) as h_combobox -- 下拉框类型
    ,nvl(n.h_textarea, o.h_textarea) as h_textarea -- 文本域类型
    ,nvl(n.hx_industy, o.hx_industy) as hx_industy -- 最终投向行业-大类
    ,nvl(n.hx_industy_detail, o.hx_industy_detail) as hx_industy_detail -- 最终投向行业-细类
    ,nvl(n.rh_custeconomypart, o.rh_custeconomypart) as rh_custeconomypart -- 客户国民经济部门
    ,nvl(n.rh_businesstype, o.rh_businesstype) as rh_businesstype -- 所属行业
    ,nvl(n.rh_isrelevancy, o.rh_isrelevancy) as rh_isrelevancy -- 是否关联方
    ,nvl(n.rh_code, o.rh_code) as rh_code -- 代码
    ,nvl(n.rh_institutioncode, o.rh_institutioncode) as rh_institutioncode -- 金融机构编码
    ,nvl(n.rh_depositaccount, o.rh_depositaccount) as rh_depositaccount -- 基本存款账户
    ,nvl(n.rh_economicsector, o.rh_economicsector) as rh_economicsector -- 经济成分
    ,nvl(n.rh_bankname, o.rh_bankname) as rh_bankname -- 基本账户开户行名称
    ,nvl(n.rh_regist, o.rh_regist) as rh_regist -- 注册地址
    ,nvl(n.rh_innerrate, o.rh_innerrate) as rh_innerrate -- 内部评级
    ,nvl(n.rh_firmsize, o.rh_firmsize) as rh_firmsize -- 企业规模
    ,nvl(n.rh_begindate, o.rh_begindate) as rh_begindate -- 成立日期
    ,nvl(n.rh_registcode, o.rh_registcode) as rh_registcode -- 注册地行政区划码
    ,nvl(n.rh_codetype, o.rh_codetype) as rh_codetype -- 代码类别
    ,nvl(n.rh_custtype, o.rh_custtype) as rh_custtype -- 客户类别
    ,nvl(n.hx_juridical_p_cert_type, o.hx_juridical_p_cert_type) as hx_juridical_p_cert_type -- 法人证件类型
    ,nvl(n.hx_juridical_p_cert_code, o.hx_juridical_p_cert_code) as hx_juridical_p_cert_code -- 法人证件号码
    ,nvl(n.hx_pd_of_vali4juridical_p_cert, o.hx_pd_of_vali4juridical_p_cert) as hx_pd_of_vali4juridical_p_cert -- 法人证件有效期
    ,nvl(n.funds_prsv, o.funds_prsv) as funds_prsv -- 资管产品统计编码
    ,nvl(n.prim_org_ptyid, o.prim_org_ptyid) as prim_org_ptyid -- 主机构客户号
    ,nvl(n.spv_cd, o.spv_cd) as spv_cd -- spv代码
    ,nvl(n.spv_name, o.spv_name) as spv_name -- spv名称
    ,nvl(n.spv_type, o.spv_type) as spv_type -- spv类型
    ,nvl(n.rh_businesstype_m, o.rh_businesstype_m) as rh_businesstype_m -- 行业类型,数据标准落标,触发器添加
    ,nvl(n.rh_economicsector_m, o.rh_economicsector_m) as rh_economicsector_m -- 经济成分,数据标准落标,触发器添加
    ,nvl(n.hx_adminiarea, o.hx_adminiarea) as hx_adminiarea -- 行政区划代码
    ,nvl(n.hx_deteilarea, o.hx_deteilarea) as hx_deteilarea -- 详细地址(不含行政区划)
    ,nvl(n.hx_deteiladdress, o.hx_deteiladdress) as hx_deteiladdress -- 详细地址(含行政区划)
    ,case when
            n.i_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_institution_ext_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_institution_ext where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_id = n.i_id
where (
        o.i_id is null
    )
    or (
        n.i_id is null
    )
    or (
        o.h_datefield <> n.h_datefield
        or o.h_textfield <> n.h_textfield
        or o.h_numberfield <> n.h_numberfield
        or o.h_combobox <> n.h_combobox
        or o.h_textarea <> n.h_textarea
        or o.hx_industy <> n.hx_industy
        or o.hx_industy_detail <> n.hx_industy_detail
        or o.rh_custeconomypart <> n.rh_custeconomypart
        or o.rh_businesstype <> n.rh_businesstype
        or o.rh_isrelevancy <> n.rh_isrelevancy
        or o.rh_code <> n.rh_code
        or o.rh_institutioncode <> n.rh_institutioncode
        or o.rh_depositaccount <> n.rh_depositaccount
        or o.rh_economicsector <> n.rh_economicsector
        or o.rh_bankname <> n.rh_bankname
        or o.rh_regist <> n.rh_regist
        or o.rh_innerrate <> n.rh_innerrate
        or o.rh_firmsize <> n.rh_firmsize
        or o.rh_begindate <> n.rh_begindate
        or o.rh_registcode <> n.rh_registcode
        or o.rh_codetype <> n.rh_codetype
        or o.rh_custtype <> n.rh_custtype
        or o.hx_juridical_p_cert_type <> n.hx_juridical_p_cert_type
        or o.hx_juridical_p_cert_code <> n.hx_juridical_p_cert_code
        or o.hx_pd_of_vali4juridical_p_cert <> n.hx_pd_of_vali4juridical_p_cert
        or o.funds_prsv <> n.funds_prsv
        or o.prim_org_ptyid <> n.prim_org_ptyid
        or o.spv_cd <> n.spv_cd
        or o.spv_name <> n.spv_name
        or o.spv_type <> n.spv_type
        or o.rh_businesstype_m <> n.rh_businesstype_m
        or o.rh_economicsector_m <> n.rh_economicsector_m
        or o.hx_adminiarea <> n.hx_adminiarea
        or o.hx_deteilarea <> n.hx_deteilarea
        or o.hx_deteiladdress <> n.hx_deteiladdress
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_institution_ext_cl(
            i_id -- 主键
            ,h_datefield -- 日期类型
            ,h_textfield -- 文本类型
            ,h_numberfield -- 数值类型
            ,h_combobox -- 下拉框类型
            ,h_textarea -- 文本域类型
            ,hx_industy -- 最终投向行业-大类
            ,hx_industy_detail -- 最终投向行业-细类
            ,rh_custeconomypart -- 客户国民经济部门
            ,rh_businesstype -- 所属行业
            ,rh_isrelevancy -- 是否关联方
            ,rh_code -- 代码
            ,rh_institutioncode -- 金融机构编码
            ,rh_depositaccount -- 基本存款账户
            ,rh_economicsector -- 经济成分
            ,rh_bankname -- 基本账户开户行名称
            ,rh_regist -- 注册地址
            ,rh_innerrate -- 内部评级
            ,rh_firmsize -- 企业规模
            ,rh_begindate -- 成立日期
            ,rh_registcode -- 注册地行政区划码
            ,rh_codetype -- 代码类别
            ,rh_custtype -- 客户类别
            ,hx_juridical_p_cert_type -- 法人证件类型
            ,hx_juridical_p_cert_code -- 法人证件号码
            ,hx_pd_of_vali4juridical_p_cert -- 法人证件有效期
            ,funds_prsv -- 资管产品统计编码
            ,prim_org_ptyid -- 主机构客户号
            ,spv_cd -- spv代码
            ,spv_name -- spv名称
            ,spv_type -- spv类型
            ,rh_businesstype_m -- 行业类型,数据标准落标,触发器添加
            ,rh_economicsector_m -- 经济成分,数据标准落标,触发器添加
            ,hx_adminiarea -- 行政区划代码
            ,hx_deteilarea -- 详细地址(不含行政区划)
            ,hx_deteiladdress -- 详细地址(含行政区划)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_institution_ext_op(
            i_id -- 主键
            ,h_datefield -- 日期类型
            ,h_textfield -- 文本类型
            ,h_numberfield -- 数值类型
            ,h_combobox -- 下拉框类型
            ,h_textarea -- 文本域类型
            ,hx_industy -- 最终投向行业-大类
            ,hx_industy_detail -- 最终投向行业-细类
            ,rh_custeconomypart -- 客户国民经济部门
            ,rh_businesstype -- 所属行业
            ,rh_isrelevancy -- 是否关联方
            ,rh_code -- 代码
            ,rh_institutioncode -- 金融机构编码
            ,rh_depositaccount -- 基本存款账户
            ,rh_economicsector -- 经济成分
            ,rh_bankname -- 基本账户开户行名称
            ,rh_regist -- 注册地址
            ,rh_innerrate -- 内部评级
            ,rh_firmsize -- 企业规模
            ,rh_begindate -- 成立日期
            ,rh_registcode -- 注册地行政区划码
            ,rh_codetype -- 代码类别
            ,rh_custtype -- 客户类别
            ,hx_juridical_p_cert_type -- 法人证件类型
            ,hx_juridical_p_cert_code -- 法人证件号码
            ,hx_pd_of_vali4juridical_p_cert -- 法人证件有效期
            ,funds_prsv -- 资管产品统计编码
            ,prim_org_ptyid -- 主机构客户号
            ,spv_cd -- spv代码
            ,spv_name -- spv名称
            ,spv_type -- spv类型
            ,rh_businesstype_m -- 行业类型,数据标准落标,触发器添加
            ,rh_economicsector_m -- 经济成分,数据标准落标,触发器添加
            ,hx_adminiarea -- 行政区划代码
            ,hx_deteilarea -- 详细地址(不含行政区划)
            ,hx_deteiladdress -- 详细地址(含行政区划)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_id -- 主键
    ,o.h_datefield -- 日期类型
    ,o.h_textfield -- 文本类型
    ,o.h_numberfield -- 数值类型
    ,o.h_combobox -- 下拉框类型
    ,o.h_textarea -- 文本域类型
    ,o.hx_industy -- 最终投向行业-大类
    ,o.hx_industy_detail -- 最终投向行业-细类
    ,o.rh_custeconomypart -- 客户国民经济部门
    ,o.rh_businesstype -- 所属行业
    ,o.rh_isrelevancy -- 是否关联方
    ,o.rh_code -- 代码
    ,o.rh_institutioncode -- 金融机构编码
    ,o.rh_depositaccount -- 基本存款账户
    ,o.rh_economicsector -- 经济成分
    ,o.rh_bankname -- 基本账户开户行名称
    ,o.rh_regist -- 注册地址
    ,o.rh_innerrate -- 内部评级
    ,o.rh_firmsize -- 企业规模
    ,o.rh_begindate -- 成立日期
    ,o.rh_registcode -- 注册地行政区划码
    ,o.rh_codetype -- 代码类别
    ,o.rh_custtype -- 客户类别
    ,o.hx_juridical_p_cert_type -- 法人证件类型
    ,o.hx_juridical_p_cert_code -- 法人证件号码
    ,o.hx_pd_of_vali4juridical_p_cert -- 法人证件有效期
    ,o.funds_prsv -- 资管产品统计编码
    ,o.prim_org_ptyid -- 主机构客户号
    ,o.spv_cd -- spv代码
    ,o.spv_name -- spv名称
    ,o.spv_type -- spv类型
    ,o.rh_businesstype_m -- 行业类型,数据标准落标,触发器添加
    ,o.rh_economicsector_m -- 经济成分,数据标准落标,触发器添加
    ,o.hx_adminiarea -- 行政区划代码
    ,o.hx_deteilarea -- 详细地址(不含行政区划)
    ,o.hx_deteiladdress -- 详细地址(含行政区划)
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
from ${iol_schema}.ibms_ttrd_institution_ext_bk o
    left join ${iol_schema}.ibms_ttrd_institution_ext_op n
        on
            o.i_id = n.i_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_institution_ext_cl d
        on
            o.i_id = d.i_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_institution_ext;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_institution_ext') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_institution_ext drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_institution_ext add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_institution_ext exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_institution_ext_cl;
alter table ${iol_schema}.ibms_ttrd_institution_ext exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_institution_ext_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_institution_ext to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_institution_ext_op purge;
drop table ${iol_schema}.ibms_ttrd_institution_ext_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_institution_ext_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_institution_ext',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
