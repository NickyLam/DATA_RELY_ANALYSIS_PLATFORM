/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_guaranty_rightinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_guaranty_rightinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_guaranty_rightinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_guaranty_rightinfo(
    rightinfono varchar2(64) -- 记录编号
    ,inputdate varchar2(64) -- 登记日期
    ,guarantyid varchar2(64) -- 资产编号
    ,otherrightflag varchar2(12) -- 是否存在他项权利
    ,inputuserid varchar2(64) -- 登记人
    ,rightkeeper varchar2(64) -- 权证保管人
    ,updateorgid varchar2(64) -- 更新机构
    ,fileno varchar2(64) -- 影像平台编号
    ,updatedate varchar2(64) -- 更新日期
    ,deliverydate varchar2(64) -- 权证交付日期
    ,deliveryperson varchar2(64) -- 权证交付人
    ,inputorgid varchar2(64) -- 登记机构
    ,rightkeepadd varchar2(1000) -- 权证保管地点
    ,tmsp varchar2(64) -- 时间戳
    ,otherrightinfo varchar2(2000) -- 他项权利说明
    ,updateuserid varchar2(64) -- 更新人
    ,deleteflag varchar2(12) -- 删除标志
    ,rightid varchar2(64) -- 权证编号
    ,rightdate varchar2(64) -- 取得权证日期
    ,rightname varchar2(400) -- 权证名称
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
grant select on ${iol_schema}.icms_ap_guaranty_rightinfo to ${iml_schema};
grant select on ${iol_schema}.icms_ap_guaranty_rightinfo to ${icl_schema};
grant select on ${iol_schema}.icms_ap_guaranty_rightinfo to ${idl_schema};
grant select on ${iol_schema}.icms_ap_guaranty_rightinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_guaranty_rightinfo is '新权证信息表';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.rightinfono is '记录编号';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.guarantyid is '资产编号';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.otherrightflag is '是否存在他项权利';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.rightkeeper is '权证保管人';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.deliverydate is '权证交付日期';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.deliveryperson is '权证交付人';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.rightkeepadd is '权证保管地点';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.otherrightinfo is '他项权利说明';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.rightid is '权证编号';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.rightdate is '取得权证日期';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.rightname is '权证名称';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_guaranty_rightinfo.etl_timestamp is 'ETL处理时间戳';
