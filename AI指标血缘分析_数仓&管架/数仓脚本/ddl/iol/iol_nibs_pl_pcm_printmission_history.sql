/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_pl_pcm_printmission_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_pl_pcm_printmission_history
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_pl_pcm_printmission_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_pl_pcm_printmission_history(
    transdate varchar2(8) -- 申请日期
    ,transtime varchar2(8) -- 申请时间
    ,brno varchar2(20) -- 机构号
    ,idcode varchar2(20) -- 识别码
    ,busiserialno varchar2(50) -- 业务流水
    ,transcode varchar2(40) -- 交易码
    ,transname varchar2(150) -- 交易名称
    ,prooftype varchar2(20) -- 凭证类型
    ,proofnum varchar2(3) -- 凭证联数
    ,sealnum varchar2(3) -- 印章编号
    ,proofno varchar2(20) -- 凭证号码
    ,printtype varchar2(20) -- 用印类型  0-自动用印 1-手动用印 2-流水勾兑
    ,missionstatus varchar2(6) -- 任务状态 0-未盖章 1-识别识别码异常 2-第一次拍照异常 3-盖章异常 4-第二次拍照异常 5-照片合成异常 6-影像流水上传异常 7-已盖章 8-已作废 9-超期作废
    ,printdate varchar2(20) -- 用印日期
    ,teller varchar2(20) -- 申请柜员
    ,authorize varchar2(20) -- 授权柜员
    ,authorg varchar2(15) -- 授权柜员机构
    ,channel varchar2(6) -- 渠道
    ,acctno varchar2(30) -- 账号
    ,acctname varchar2(150) -- 户名
    ,photobeofre varchar2(150) -- 第一张照片在服务器的地址
    ,photoafter varchar2(150) -- 第二张照片在服务器的地址
    ,photocombination varchar2(150) -- 合成照片在服务器的地址
    ,pcmno varchar2(20) -- 印控机编号
    ,idcount varchar2(3) -- 需要盖章次数
    ,changetime varchar2(20) -- 状态废除时间
    ,changestatus varchar2(6) -- 废除前状态
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
grant select on ${iol_schema}.nibs_pl_pcm_printmission_history to ${iml_schema};
grant select on ${iol_schema}.nibs_pl_pcm_printmission_history to ${icl_schema};
grant select on ${iol_schema}.nibs_pl_pcm_printmission_history to ${idl_schema};
grant select on ${iol_schema}.nibs_pl_pcm_printmission_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_pl_pcm_printmission_history is '印控机用印信息表';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.transdate is '申请日期';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.transtime is '申请时间';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.brno is '机构号';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.idcode is '识别码';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.busiserialno is '业务流水';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.transcode is '交易码';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.transname is '交易名称';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.prooftype is '凭证类型';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.proofnum is '凭证联数';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.sealnum is '印章编号';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.proofno is '凭证号码';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.printtype is '用印类型  0-自动用印 1-手动用印 2-流水勾兑';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.missionstatus is '任务状态 0-未盖章 1-识别识别码异常 2-第一次拍照异常 3-盖章异常 4-第二次拍照异常 5-照片合成异常 6-影像流水上传异常 7-已盖章 8-已作废 9-超期作废';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.printdate is '用印日期';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.teller is '申请柜员';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.authorize is '授权柜员';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.authorg is '授权柜员机构';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.channel is '渠道';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.acctno is '账号';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.acctname is '户名';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.photobeofre is '第一张照片在服务器的地址';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.photoafter is '第二张照片在服务器的地址';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.photocombination is '合成照片在服务器的地址';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.pcmno is '印控机编号';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.idcount is '需要盖章次数';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.changetime is '状态废除时间';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.changestatus is '废除前状态';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_pl_pcm_printmission_history.etl_timestamp is 'ETL处理时间戳';
