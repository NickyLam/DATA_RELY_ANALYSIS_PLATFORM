/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_doc_attachment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_doc_attachment
whenever sqlerror continue none;
drop table ${iol_schema}.icms_doc_attachment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_doc_attachment(
    attachmentno varchar2(64) -- 附件编号
    ,filename varchar2(1000) -- 文件名
    ,contenttype varchar2(400) -- 内容类型
    ,contentlength varchar2(64) -- 内容长度
    ,contentstatus varchar2(64) -- 内容状态
    ,doccontent varchar2(4000) -- 文档内容
    ,remark varchar2(1000) -- 备注
    ,filepath varchar2(400) -- 文件路径
    ,fullpath varchar2(1000) -- 文件全路径
    ,filesavemode varchar2(64) -- 文件保存类型
    ,objecttype varchar2(64) -- 对象类型
    ,objectno varchar2(64) -- 对象编号
    ,begintime date -- 发送开始时间
    ,endtime date -- 发送完成时间
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,filebusicode varchar2(150) -- esb文件管理平台唯一标识
    ,oldattachmentno varchar2(64) -- 原附件编号
    ,migtflag varchar2(80) -- 
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
grant select on ${iol_schema}.icms_doc_attachment to ${iml_schema};
grant select on ${iol_schema}.icms_doc_attachment to ${icl_schema};
grant select on ${iol_schema}.icms_doc_attachment to ${idl_schema};
grant select on ${iol_schema}.icms_doc_attachment to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_doc_attachment is '文档附件表';
comment on column ${iol_schema}.icms_doc_attachment.attachmentno is '附件编号';
comment on column ${iol_schema}.icms_doc_attachment.filename is '文件名';
comment on column ${iol_schema}.icms_doc_attachment.contenttype is '内容类型';
comment on column ${iol_schema}.icms_doc_attachment.contentlength is '内容长度';
comment on column ${iol_schema}.icms_doc_attachment.contentstatus is '内容状态';
comment on column ${iol_schema}.icms_doc_attachment.doccontent is '文档内容';
comment on column ${iol_schema}.icms_doc_attachment.remark is '备注';
comment on column ${iol_schema}.icms_doc_attachment.filepath is '文件路径';
comment on column ${iol_schema}.icms_doc_attachment.fullpath is '文件全路径';
comment on column ${iol_schema}.icms_doc_attachment.filesavemode is '文件保存类型';
comment on column ${iol_schema}.icms_doc_attachment.objecttype is '对象类型';
comment on column ${iol_schema}.icms_doc_attachment.objectno is '对象编号';
comment on column ${iol_schema}.icms_doc_attachment.begintime is '发送开始时间';
comment on column ${iol_schema}.icms_doc_attachment.endtime is '发送完成时间';
comment on column ${iol_schema}.icms_doc_attachment.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_doc_attachment.inputuserid is '登记人';
comment on column ${iol_schema}.icms_doc_attachment.inputdate is '登记日期';
comment on column ${iol_schema}.icms_doc_attachment.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_doc_attachment.updateuserid is '更新人';
comment on column ${iol_schema}.icms_doc_attachment.updatedate is '更新日期';
comment on column ${iol_schema}.icms_doc_attachment.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_doc_attachment.filebusicode is 'esb文件管理平台唯一标识';
comment on column ${iol_schema}.icms_doc_attachment.oldattachmentno is '原附件编号';
comment on column ${iol_schema}.icms_doc_attachment.migtflag is '';
comment on column ${iol_schema}.icms_doc_attachment.start_dt is '开始时间';
comment on column ${iol_schema}.icms_doc_attachment.end_dt is '结束时间';
comment on column ${iol_schema}.icms_doc_attachment.id_mark is '增删标志';
comment on column ${iol_schema}.icms_doc_attachment.etl_timestamp is 'ETL处理时间戳';
