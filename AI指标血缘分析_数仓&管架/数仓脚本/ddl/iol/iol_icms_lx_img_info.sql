/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_img_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_img_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_img_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_img_info(
    serialno varchar2(64) -- 流水号
    ,relserialno varchar2(64) -- 关联的授信申请流水号
    ,creditapplyid varchar2(32) -- 乐信的申请编号(资产号)
    ,filetype varchar2(10) -- 文件类型
    ,filepath varchar2(1000) -- 文件路径
    ,filename varchar2(200) -- 文件名
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_lx_img_info to ${iml_schema};
grant select on ${iol_schema}.icms_lx_img_info to ${icl_schema};
grant select on ${iol_schema}.icms_lx_img_info to ${idl_schema};
grant select on ${iol_schema}.icms_lx_img_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_img_info is '乐信影像文件信息表';
comment on column ${iol_schema}.icms_lx_img_info.serialno is '流水号';
comment on column ${iol_schema}.icms_lx_img_info.relserialno is '关联的授信申请流水号';
comment on column ${iol_schema}.icms_lx_img_info.creditapplyid is '乐信的申请编号(资产号)';
comment on column ${iol_schema}.icms_lx_img_info.filetype is '文件类型';
comment on column ${iol_schema}.icms_lx_img_info.filepath is '文件路径';
comment on column ${iol_schema}.icms_lx_img_info.filename is '文件名';
comment on column ${iol_schema}.icms_lx_img_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_img_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_img_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lx_img_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_img_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_img_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lx_img_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lx_img_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lx_img_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lx_img_info.etl_timestamp is 'ETL处理时间戳';
