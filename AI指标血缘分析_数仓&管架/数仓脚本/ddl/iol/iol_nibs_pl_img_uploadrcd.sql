/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_pl_img_uploadrcd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_pl_img_uploadrcd
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_pl_img_uploadrcd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_pl_img_uploadrcd(
    channelcode varchar2(6) -- 渠道编号
    ,modelcode varchar2(10) -- 影像模型
    ,busi_date varchar2(10) -- 业务日期
    ,busi_time varchar2(10) -- 业务时间
    ,busi_serial_no varchar2(64) -- 业务流水号
    ,uploadfile varchar2(4000) -- 上传文件列表
    ,content_id varchar2(50) -- 影像批次号
    ,securitycode varchar2(20) -- 防伪码
    ,eipaddr varchar2(20) -- 影像地址
    ,uploaddate varchar2(10) -- 更新日期
    ,uploadtime varchar2(10) -- 更新时间
    ,remark varchar2(500) -- 备注
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
grant select on ${iol_schema}.nibs_pl_img_uploadrcd to ${iml_schema};
grant select on ${iol_schema}.nibs_pl_img_uploadrcd to ${icl_schema};
grant select on ${iol_schema}.nibs_pl_img_uploadrcd to ${idl_schema};
grant select on ${iol_schema}.nibs_pl_img_uploadrcd to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_pl_img_uploadrcd is '印控机装章取章视频表';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.channelcode is '渠道编号';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.modelcode is '影像模型';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.busi_date is '业务日期';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.busi_time is '业务时间';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.busi_serial_no is '业务流水号';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.uploadfile is '上传文件列表';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.content_id is '影像批次号';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.securitycode is '防伪码';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.eipaddr is '影像地址';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.uploaddate is '更新日期';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.uploadtime is '更新时间';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.remark is '备注';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_pl_img_uploadrcd.etl_timestamp is 'ETL处理时间戳';
