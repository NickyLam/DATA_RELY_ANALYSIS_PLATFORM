/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_assetpackageinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_assetpackageinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_assetpackageinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_assetpackageinfo(
    sertalno varchar2(48) -- 资产包编号
    ,apname varchar2(38) -- 资产包名称
    ,status varchar2(3) -- 资产包状态
    ,transdate varchar2(15) -- 转让日
    ,updatedate varchar2(15) -- 更新时间
    ,filereadflag varchar2(2) -- 是否已读取文件 0-未读取 1-读取
    ,flag varchar2(2) -- 资产包是否有效 0-无效 1-有效
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mims_si_assetpackageinfo to ${iml_schema};
grant select on ${iol_schema}.mims_si_assetpackageinfo to ${icl_schema};
grant select on ${iol_schema}.mims_si_assetpackageinfo to ${idl_schema};
grant select on ${iol_schema}.mims_si_assetpackageinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_assetpackageinfo is '用于记录信贷资产包信息';
comment on column ${iol_schema}.mims_si_assetpackageinfo.sertalno is '资产包编号';
comment on column ${iol_schema}.mims_si_assetpackageinfo.apname is '资产包名称';
comment on column ${iol_schema}.mims_si_assetpackageinfo.status is '资产包状态';
comment on column ${iol_schema}.mims_si_assetpackageinfo.transdate is '转让日';
comment on column ${iol_schema}.mims_si_assetpackageinfo.updatedate is '更新时间';
comment on column ${iol_schema}.mims_si_assetpackageinfo.filereadflag is '是否已读取文件 0-未读取 1-读取';
comment on column ${iol_schema}.mims_si_assetpackageinfo.flag is '资产包是否有效 0-无效 1-有效';
comment on column ${iol_schema}.mims_si_assetpackageinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_assetpackageinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_assetpackageinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_assetpackageinfo.etl_timestamp is 'ETL处理时间戳';
