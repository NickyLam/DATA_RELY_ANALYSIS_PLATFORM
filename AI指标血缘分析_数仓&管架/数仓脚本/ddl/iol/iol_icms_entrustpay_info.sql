/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_entrustpay_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_entrustpay_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_entrustpay_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_entrustpay_info(
    serialno varchar2(40) -- 受托支付编号
    ,relativeserialno varchar2(40) -- 出账流水号
    ,entrustpaysum number(24,6) -- 受托支付总金额
    ,accnumberpay number(24,6) -- 受托支付总笔数
    ,latestdate varchar2(40) -- 受托支付最迟支付日期
    ,attribute1 varchar2(250) -- 属性1
    ,attribute2 varchar2(250) -- 属性2
    ,attribute3 varchar2(250) -- 属性3
    ,attribute4 varchar2(250) -- 属性4
    ,attribute5 varchar2(250) -- 属性5
    ,remark varchar2(200) -- 备注leng
    ,isinuse varchar2(1) -- 添加维护标志1正常2不维护
    ,loanstatus varchar2(20) -- 支付状态：finished-已完成
    ,effectflag varchar2(20) -- 生效标志：unvalid-已失效
    ,inputdate date -- 登记日期
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(8) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
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
grant select on ${iol_schema}.icms_entrustpay_info to ${iml_schema};
grant select on ${iol_schema}.icms_entrustpay_info to ${icl_schema};
grant select on ${iol_schema}.icms_entrustpay_info to ${idl_schema};
grant select on ${iol_schema}.icms_entrustpay_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_entrustpay_info is '受托支付记录汇总表';
comment on column ${iol_schema}.icms_entrustpay_info.serialno is '受托支付编号';
comment on column ${iol_schema}.icms_entrustpay_info.relativeserialno is '出账流水号';
comment on column ${iol_schema}.icms_entrustpay_info.entrustpaysum is '受托支付总金额';
comment on column ${iol_schema}.icms_entrustpay_info.accnumberpay is '受托支付总笔数';
comment on column ${iol_schema}.icms_entrustpay_info.latestdate is '受托支付最迟支付日期';
comment on column ${iol_schema}.icms_entrustpay_info.attribute1 is '属性1';
comment on column ${iol_schema}.icms_entrustpay_info.attribute2 is '属性2';
comment on column ${iol_schema}.icms_entrustpay_info.attribute3 is '属性3';
comment on column ${iol_schema}.icms_entrustpay_info.attribute4 is '属性4';
comment on column ${iol_schema}.icms_entrustpay_info.attribute5 is '属性5';
comment on column ${iol_schema}.icms_entrustpay_info.remark is '备注leng';
comment on column ${iol_schema}.icms_entrustpay_info.isinuse is '添加维护标志1正常2不维护';
comment on column ${iol_schema}.icms_entrustpay_info.loanstatus is '支付状态：finished-已完成';
comment on column ${iol_schema}.icms_entrustpay_info.effectflag is '生效标志：unvalid-已失效';
comment on column ${iol_schema}.icms_entrustpay_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_entrustpay_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_entrustpay_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_entrustpay_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_entrustpay_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_entrustpay_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_entrustpay_info.migtflag is '';
comment on column ${iol_schema}.icms_entrustpay_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_entrustpay_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_entrustpay_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_entrustpay_info.etl_timestamp is 'ETL处理时间戳';
