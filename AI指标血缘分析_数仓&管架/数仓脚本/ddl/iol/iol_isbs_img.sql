/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_img
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_img
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_img purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_img(
    inr varchar2(12) -- 数据序号
    ,msgid varchar2(53) -- 报文标识号
    ,objtyp varchar2(9) -- 关联业务表类型
    ,objinr varchar2(12) -- 关联业务表inr
    ,fileid varchar2(75) -- 人行回传影像id
    ,filnam varchar2(120) -- 影像名称
    ,filpth varchar2(120) -- 文件存放路径
    ,inifrm varchar2(9) -- 对应的业务交易
    ,filefrm varchar2(6) -- 影像类别
    ,filetype varchar2(6) -- 影像类型
    ,filedesc varchar2(180) -- 影像描述
    ,vldflg varchar2(6) -- 有效标识
    ,fpid varchar2(75) -- 发票影像id
    ,invtp varchar2(6) -- 发票类型
    ,invnb varchar2(30) -- 发票号码
    ,invoicecode varchar2(30) -- 发票代码
    ,untaxamt number(18,3) -- 未税金额
    ,invdt date -- 开票日期
    ,yxflg varchar2(2) -- 影像分类
    ,branch varchar2(12) -- 所属机构
    ,ownref varchar2(60) -- 业务编号
    ,delflg varchar2(2) -- 删除标志
    ,updow varchar2(5) -- 上传/下载
    ,isdow varchar2(2) -- 下载成功标志
    ,usrkey varchar2(15) -- 柜员号
    ,credat timestamp -- 创建时间
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
grant select on ${iol_schema}.isbs_img to ${iml_schema};
grant select on ${iol_schema}.isbs_img to ${icl_schema};
grant select on ${iol_schema}.isbs_img to ${idl_schema};
grant select on ${iol_schema}.isbs_img to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_img is '发票信息表';
comment on column ${iol_schema}.isbs_img.inr is '数据序号';
comment on column ${iol_schema}.isbs_img.msgid is '报文标识号';
comment on column ${iol_schema}.isbs_img.objtyp is '关联业务表类型';
comment on column ${iol_schema}.isbs_img.objinr is '关联业务表inr';
comment on column ${iol_schema}.isbs_img.fileid is '人行回传影像id';
comment on column ${iol_schema}.isbs_img.filnam is '影像名称';
comment on column ${iol_schema}.isbs_img.filpth is '文件存放路径';
comment on column ${iol_schema}.isbs_img.inifrm is '对应的业务交易';
comment on column ${iol_schema}.isbs_img.filefrm is '影像类别';
comment on column ${iol_schema}.isbs_img.filetype is '影像类型';
comment on column ${iol_schema}.isbs_img.filedesc is '影像描述';
comment on column ${iol_schema}.isbs_img.vldflg is '有效标识';
comment on column ${iol_schema}.isbs_img.fpid is '发票影像id';
comment on column ${iol_schema}.isbs_img.invtp is '发票类型';
comment on column ${iol_schema}.isbs_img.invnb is '发票号码';
comment on column ${iol_schema}.isbs_img.invoicecode is '发票代码';
comment on column ${iol_schema}.isbs_img.untaxamt is '未税金额';
comment on column ${iol_schema}.isbs_img.invdt is '开票日期';
comment on column ${iol_schema}.isbs_img.yxflg is '影像分类';
comment on column ${iol_schema}.isbs_img.branch is '所属机构';
comment on column ${iol_schema}.isbs_img.ownref is '业务编号';
comment on column ${iol_schema}.isbs_img.delflg is '删除标志';
comment on column ${iol_schema}.isbs_img.updow is '上传/下载';
comment on column ${iol_schema}.isbs_img.isdow is '下载成功标志';
comment on column ${iol_schema}.isbs_img.usrkey is '柜员号';
comment on column ${iol_schema}.isbs_img.credat is '创建时间';
comment on column ${iol_schema}.isbs_img.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_img.etl_timestamp is 'ETL处理时间戳';
