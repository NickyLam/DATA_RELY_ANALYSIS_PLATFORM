/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl org_int_org
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.org_int_org
whenever sqlerror continue none;
drop table ${idl_schema}.org_int_org purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.org_int_org(
    etl_dt date -- 数据日期   
    ,org_id varchar2(60) -- 机构编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,org_name varchar2(100) -- 机构名称   
    ,org_abbr varchar2(100) -- 机构简称   
    ,org_type_cd varchar2(10) -- 机构类型代码   
    ,org_found_dt date -- 机构成立日期   
    ,org_close_dt date -- 机构关闭日期   
    ,enty_org_flg varchar2(10) -- 实体机构标志   
    ,accti_org_flg varchar2(10) -- 核算机构标志   
    ,bus_org_flg varchar2(10) -- 营业机构标志   
    ,admin_org_flg varchar2(10) -- 行政机构标志   
    ,acct_instit_flg varchar2(10) -- 账务机构标志   
    ,vtual_org_flg varchar2(10) -- 虚拟机构标志   
    ,org_lev_cd varchar2(10) -- 机构级别代码   
    ,org_status_cd varchar2(10) -- 机构状态代码   
    ,org_bus_status_cd varchar2(10) -- 机构营业状态代码   
    ,unify_orgnz_id varchar2(60) -- 统一组织机构编号   
    ,fin_lics_num varchar2(60) -- 金融许可证号码   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.org_int_org to ${iel_schema};

-- comment
comment on table ${idl_schema}.org_int_org is '内部机构';
comment on column ${idl_schema}.org_int_org.etl_dt is '数据日期';
comment on column ${idl_schema}.org_int_org.org_id is '机构编号';
comment on column ${idl_schema}.org_int_org.lp_id is '法人编号';
comment on column ${idl_schema}.org_int_org.org_name is '机构名称';
comment on column ${idl_schema}.org_int_org.org_abbr is '机构简称';
comment on column ${idl_schema}.org_int_org.org_type_cd is '机构类型代码';
comment on column ${idl_schema}.org_int_org.org_found_dt is '机构成立日期';
comment on column ${idl_schema}.org_int_org.org_close_dt is '机构关闭日期';
comment on column ${idl_schema}.org_int_org.enty_org_flg is '实体机构标志';
comment on column ${idl_schema}.org_int_org.accti_org_flg is '核算机构标志';
comment on column ${idl_schema}.org_int_org.bus_org_flg is '营业机构标志';
comment on column ${idl_schema}.org_int_org.admin_org_flg is '行政机构标志';
comment on column ${idl_schema}.org_int_org.acct_instit_flg is '账务机构标志';
comment on column ${idl_schema}.org_int_org.vtual_org_flg is '虚拟机构标志';
comment on column ${idl_schema}.org_int_org.org_lev_cd is '机构级别代码';
comment on column ${idl_schema}.org_int_org.org_status_cd is '机构状态代码';
comment on column ${idl_schema}.org_int_org.org_bus_status_cd is '机构营业状态代码';
comment on column ${idl_schema}.org_int_org.unify_orgnz_id is '统一组织机构编号';
comment on column ${idl_schema}.org_int_org.fin_lics_num is '金融许可证号码';
comment on column ${idl_schema}.org_int_org.create_dt is '创建日期';
comment on column ${idl_schema}.org_int_org.update_dt is '更新日期';
comment on column ${idl_schema}.org_int_org.id_mark is '删除标识';