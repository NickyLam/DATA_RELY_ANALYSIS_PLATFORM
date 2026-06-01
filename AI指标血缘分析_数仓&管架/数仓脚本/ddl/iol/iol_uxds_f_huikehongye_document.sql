/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_huikehongye_document
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_huikehongye_document
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_huikehongye_document purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_huikehongye_document(
    gendate varchar2(4000) -- 生成时间
    ,sequenceid varchar2(4000) -- 系统流水号
    ,doc_id varchar2(4000) -- 文章号
    ,source varchar2(4000) -- 媒体名称
    ,headline varchar2(4000) -- 标题
    ,publish_time varchar2(4000) -- 发表时间
    ,author varchar2(4000) -- 作者
    ,type_id varchar2(4000) -- 媒体类型
    ,word_count varchar2(4000) -- 字数
    ,content varchar2(4000) -- 正文
    ,pub_code varchar2(4000) -- 媒体编码
    ,pub_region varchar2(4000) -- 媒体地区
    ,section varchar2(4000) -- 版面
    ,push_time varchar2(4000) -- 推送客户时间
    ,url varchar2(4000) -- 文章链接
    ,sentiment varchar2(4000) -- 情感
    ,sentiment_score varchar2(4000) -- 情感得分
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.uxds_f_huikehongye_document to ${iml_schema};
grant select on ${iol_schema}.uxds_f_huikehongye_document to ${icl_schema};
grant select on ${iol_schema}.uxds_f_huikehongye_document to ${idl_schema};
grant select on ${iol_schema}.uxds_f_huikehongye_document to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_huikehongye_document is '慧科讯业文档表';
comment on column ${iol_schema}.uxds_f_huikehongye_document.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_huikehongye_document.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_huikehongye_document.doc_id is '文章号';
comment on column ${iol_schema}.uxds_f_huikehongye_document.source is '媒体名称';
comment on column ${iol_schema}.uxds_f_huikehongye_document.headline is '标题';
comment on column ${iol_schema}.uxds_f_huikehongye_document.publish_time is '发表时间';
comment on column ${iol_schema}.uxds_f_huikehongye_document.author is '作者';
comment on column ${iol_schema}.uxds_f_huikehongye_document.type_id is '媒体类型';
comment on column ${iol_schema}.uxds_f_huikehongye_document.word_count is '字数';
comment on column ${iol_schema}.uxds_f_huikehongye_document.content is '正文';
comment on column ${iol_schema}.uxds_f_huikehongye_document.pub_code is '媒体编码';
comment on column ${iol_schema}.uxds_f_huikehongye_document.pub_region is '媒体地区';
comment on column ${iol_schema}.uxds_f_huikehongye_document.section is '版面';
comment on column ${iol_schema}.uxds_f_huikehongye_document.push_time is '推送客户时间';
comment on column ${iol_schema}.uxds_f_huikehongye_document.url is '文章链接';
comment on column ${iol_schema}.uxds_f_huikehongye_document.sentiment is '情感';
comment on column ${iol_schema}.uxds_f_huikehongye_document.sentiment_score is '情感得分';
comment on column ${iol_schema}.uxds_f_huikehongye_document.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_huikehongye_document.etl_timestamp is 'ETL处理时间戳';
