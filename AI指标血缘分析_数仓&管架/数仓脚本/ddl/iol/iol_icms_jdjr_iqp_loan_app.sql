/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_jdjr_iqp_loan_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_jdjr_iqp_loan_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_jdjr_iqp_loan_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_iqp_loan_app(
    serno varchar2(64) -- 流水号
    ,certtype varchar2(8) -- 证件类型
    ,prdname varchar2(128) -- 产品名称
    ,inputdate varchar2(10) -- 录入日期
    ,approvestatus varchar2(10) -- 审批状态
    ,autoscore varchar2(10) -- 评分卡分值
    ,execrate number(14,10) -- 执行年利率，京东推送日利率X360
    ,floatratebp number(14,10) -- 利率浮动点差BP
    ,ratetype varchar2(2) -- 利率类型1基准利率2LPR
    ,usertel varchar2(16) -- 手机号
    ,interestrate varchar2(10) -- 日利率
    ,ratefloatmode varchar2(2) -- 利率浮动方式
    ,creditmode varchar2(16) -- 授信模式
    ,address varchar2(256) -- 通讯地址
    ,prdcode varchar2(32) -- 产品代码
    ,inputbrid varchar2(32) -- 登录机构
    ,lpr number(14,10) -- LPR
    ,applytime varchar2(14) -- 申请时间
    ,businesstype varchar2(16) -- 业务场景
    ,inputid varchar2(20) -- 登记人
    ,failreason varchar2(2000) -- 拒绝原因
    ,applyno varchar2(64) -- 申请号
    ,cusid varchar2(20) -- 客户号
    ,enddate varchar2(20) -- 审批结束时间
    ,prdno varchar2(2) -- 产品编号（借据用）
    ,pin varchar2(128) -- 用户标识
    ,certno varchar2(32) -- 身份证号
    ,username varchar2(200) -- 客户姓名
    ,startdate varchar2(20) -- 审批开始时间
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,applyamount varchar2(16) -- 申请额度（元）
    ,activatetag varchar2(16) -- 激活标签
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
grant select on ${iol_schema}.icms_jdjr_iqp_loan_app to ${iml_schema};
grant select on ${iol_schema}.icms_jdjr_iqp_loan_app to ${icl_schema};
grant select on ${iol_schema}.icms_jdjr_iqp_loan_app to ${idl_schema};
grant select on ${iol_schema}.icms_jdjr_iqp_loan_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_jdjr_iqp_loan_app is '京东申请信息';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.serno is '流水号';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.certtype is '证件类型';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.prdname is '产品名称';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.inputdate is '录入日期';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.autoscore is '评分卡分值';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.execrate is '执行年利率，京东推送日利率X360';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.floatratebp is '利率浮动点差BP';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.ratetype is '利率类型1基准利率2LPR';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.usertel is '手机号';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.interestrate is '日利率';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.ratefloatmode is '利率浮动方式';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.creditmode is '授信模式';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.address is '通讯地址';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.prdcode is '产品代码';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.inputbrid is '登录机构';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.lpr is 'LPR';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.applytime is '申请时间';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.businesstype is '业务场景';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.inputid is '登记人';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.failreason is '拒绝原因';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.applyno is '申请号';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.cusid is '客户号';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.enddate is '审批结束时间';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.prdno is '产品编号（借据用）';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.pin is '用户标识';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.certno is '身份证号';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.username is '客户姓名';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.startdate is '审批开始时间';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.applyamount is '申请额度（元）';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.activatetag is '激活标签';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.start_dt is '开始时间';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.end_dt is '结束时间';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.id_mark is '增删标志';
comment on column ${iol_schema}.icms_jdjr_iqp_loan_app.etl_timestamp is 'ETL处理时间戳';
