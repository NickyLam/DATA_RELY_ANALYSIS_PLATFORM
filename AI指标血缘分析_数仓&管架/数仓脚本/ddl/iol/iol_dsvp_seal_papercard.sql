/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol dsvp_seal_papercard
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.dsvp_seal_papercard
whenever sqlerror continue none;
drop table ${iol_schema}.dsvp_seal_papercard purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.dsvp_seal_papercard(
    dbserno number -- 编号
    ,accountno varchar2(40) -- 账号
    ,sealcardno varchar2(8) -- 印鉴卡序号
    ,innercardno varchar2(20) -- 印鉴卡号
    ,sealsfront varchar2(128) -- 正面
    ,sealsback varchar2(128) -- 反面
    ,serno number -- 序号
    ,picname varchar2(128) -- 图像名称
    ,picpath varchar2(255) -- 图像路径
    ,isfront number -- 正面标识（0-否，1-是）
    ,dpi number -- 分辨率
    ,barcode varchar2(64) -- 机构编号
    ,imagetype number(38,0) -- 图像类型（0-正卡，1-副卡）
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
grant select on ${iol_schema}.dsvp_seal_papercard to ${iml_schema};
grant select on ${iol_schema}.dsvp_seal_papercard to ${icl_schema};
grant select on ${iol_schema}.dsvp_seal_papercard to ${idl_schema};
grant select on ${iol_schema}.dsvp_seal_papercard to ${iel_schema};

-- comment
comment on table ${iol_schema}.dsvp_seal_papercard is '印鉴卡表';
comment on column ${iol_schema}.dsvp_seal_papercard.dbserno is '编号';
comment on column ${iol_schema}.dsvp_seal_papercard.accountno is '账号';
comment on column ${iol_schema}.dsvp_seal_papercard.sealcardno is '印鉴卡序号';
comment on column ${iol_schema}.dsvp_seal_papercard.innercardno is '印鉴卡号';
comment on column ${iol_schema}.dsvp_seal_papercard.sealsfront is '正面';
comment on column ${iol_schema}.dsvp_seal_papercard.sealsback is '反面';
comment on column ${iol_schema}.dsvp_seal_papercard.serno is '序号';
comment on column ${iol_schema}.dsvp_seal_papercard.picname is '图像名称';
comment on column ${iol_schema}.dsvp_seal_papercard.picpath is '图像路径';
comment on column ${iol_schema}.dsvp_seal_papercard.isfront is '正面标识（0-否，1-是）';
comment on column ${iol_schema}.dsvp_seal_papercard.dpi is '分辨率';
comment on column ${iol_schema}.dsvp_seal_papercard.barcode is '机构编号';
comment on column ${iol_schema}.dsvp_seal_papercard.imagetype is '图像类型（0-正卡，1-副卡）';
comment on column ${iol_schema}.dsvp_seal_papercard.start_dt is '开始时间';
comment on column ${iol_schema}.dsvp_seal_papercard.end_dt is '结束时间';
comment on column ${iol_schema}.dsvp_seal_papercard.id_mark is '增删标志';
comment on column ${iol_schema}.dsvp_seal_papercard.etl_timestamp is 'ETL处理时间戳';
