/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_pbs_wx_tourist_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_pbs_wx_tourist_info
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_pbs_wx_tourist_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_wx_tourist_info(
    pwt_unionid varchar2(90) -- 微信UNIONID
    ,pwt_openid varchar2(90) -- 微信OPENID
    ,pwt_phone varchar2(20) -- 手机号
    ,pwt_name varchar2(60) -- 客户姓名
    ,pwt_certnum varchar2(25) -- 证件号
    ,pwt_chanel varchar2(25) -- 来源渠道
    ,pwt_sellsmscontract varchar2(5) -- 是否同意接收营销信息短信
    ,pwt_date varchar2(16) -- 注册时间
    ,pwt_status varchar2(10) -- 状态（0-有效,1-失效）
    ,pwt_tourist_id varchar2(80) -- 游客ID
    ,pwt_branchid varchar2(80) -- 机构号
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
grant select on ${iol_schema}.osbs_pbs_wx_tourist_info to ${iml_schema};
grant select on ${iol_schema}.osbs_pbs_wx_tourist_info to ${icl_schema};
grant select on ${iol_schema}.osbs_pbs_wx_tourist_info to ${idl_schema};
grant select on ${iol_schema}.osbs_pbs_wx_tourist_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_pbs_wx_tourist_info is '微信游客注册信息表';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_unionid is '微信UNIONID';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_openid is '微信OPENID';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_phone is '手机号';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_name is '客户姓名';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_certnum is '证件号';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_chanel is '来源渠道';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_sellsmscontract is '是否同意接收营销信息短信';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_date is '注册时间';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_status is '状态（0-有效,1-失效）';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_tourist_id is '游客ID';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.pwt_branchid is '机构号';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_pbs_wx_tourist_info.etl_timestamp is 'ETL处理时间戳';
