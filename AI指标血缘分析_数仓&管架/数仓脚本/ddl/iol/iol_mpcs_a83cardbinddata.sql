/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a83cardbinddata
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a83cardbinddata
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a83cardbinddata purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a83cardbinddata(
    custno varchar2(30) -- 客户号
    ,opendate varchar2(12) -- 用户开户日期
    ,qyjhdate varchar2(12) -- 用户权益激活时间
    ,yshacctno varchar2(45) -- 映山红卡号
    ,yshacctclass varchar2(2) -- 映山红卡等级 0-映山红卡 1-映山红钻石卡
    ,ltacctno varchar2(45) -- 龙腾卡卡号
    ,ltacctclass varchar2(2) -- 龙腾卡等级 0-白金 1-钻石
    ,ltacctpw varchar2(45) -- 龙腾卡初始密码
    ,iptftp varchar2(2) -- 用户证件类型
    ,iptfno varchar2(45) -- 类型证件号码
    ,sex varchar2(2) -- 性别 f-女 m-男
    ,custname varchar2(60) -- 客户姓名
    ,custphone varchar2(30) -- 客户手机号
    ,openuser varchar2(15) -- 操作柜员
    ,openbrchno varchar2(15) -- 开户机构
    ,custaddr varchar2(300) -- 客户地址
    ,acctstate varchar2(2) -- 卡状态 0 正常  2注销 3 挂失 4挂失未激活（网银侧使用）
    ,qystate varchar2(2) -- 权益状态 0 正常 1 冻结 2 注销
    ,opentag varchar2(2) -- 开卡方式 0-  资产达标 1-  特批开卡
    ,amtsettag varchar2(2) -- 管理费收取 0-收管理费 1-一年内免收 2-两年内免收 3-三年内免收 4-终身免费
    ,amtenddate varchar2(15) -- 免费终止日期
    ,accountno varchar2(2) -- 管理费核算机构 0-总行 1-分行
    ,remark varchar2(1500) -- 特批说明
    ,acctamt number(20,2) -- 冻结，欠费金额
    ,acctoperdate varchar2(15) -- 冻结解冻日期
    ,acctnochg varchar2(45) -- 换卡-前映山红卡号
    ,acctstatechg varchar2(2) -- 换卡-前映山红卡级别
    ,amtfeetag varchar2(2) -- 批量扣收管理费结果状态 0-成功 1-初次批扣失败 2-补扣失败
    ,acctfreesum number(22,0) -- 用户被冻结次数；初始值为0
    ,transtag varchar2(2) -- 1 非映山红卡换映山红卡,2 映山红卡换非映山红卡,3 同等级换卡,4 升级换卡 5 降级换卡 6-注销 7-解挂补开 8-管理费标识维护
    ,dealdate varchar2(30) -- 操作日期
    ,remark1 varchar2(45) -- 
    ,remark2 varchar2(45) -- 
    ,remark3 varchar2(75) -- 
    ,remark4 varchar2(750) -- 
    ,remark5 varchar2(750) -- 
    ,remark6 varchar2(750) -- 
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
grant select on ${iol_schema}.mpcs_a83cardbinddata to ${iml_schema};
grant select on ${iol_schema}.mpcs_a83cardbinddata to ${icl_schema};
grant select on ${iol_schema}.mpcs_a83cardbinddata to ${idl_schema};
grant select on ${iol_schema}.mpcs_a83cardbinddata to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a83cardbinddata is '中台绑定数据表';
comment on column ${iol_schema}.mpcs_a83cardbinddata.custno is '客户号';
comment on column ${iol_schema}.mpcs_a83cardbinddata.opendate is '用户开户日期';
comment on column ${iol_schema}.mpcs_a83cardbinddata.qyjhdate is '用户权益激活时间';
comment on column ${iol_schema}.mpcs_a83cardbinddata.yshacctno is '映山红卡号';
comment on column ${iol_schema}.mpcs_a83cardbinddata.yshacctclass is '映山红卡等级 0-映山红卡 1-映山红钻石卡';
comment on column ${iol_schema}.mpcs_a83cardbinddata.ltacctno is '龙腾卡卡号';
comment on column ${iol_schema}.mpcs_a83cardbinddata.ltacctclass is '龙腾卡等级 0-白金 1-钻石';
comment on column ${iol_schema}.mpcs_a83cardbinddata.ltacctpw is '龙腾卡初始密码';
comment on column ${iol_schema}.mpcs_a83cardbinddata.iptftp is '用户证件类型';
comment on column ${iol_schema}.mpcs_a83cardbinddata.iptfno is '类型证件号码';
comment on column ${iol_schema}.mpcs_a83cardbinddata.sex is '性别 f-女 m-男';
comment on column ${iol_schema}.mpcs_a83cardbinddata.custname is '客户姓名';
comment on column ${iol_schema}.mpcs_a83cardbinddata.custphone is '客户手机号';
comment on column ${iol_schema}.mpcs_a83cardbinddata.openuser is '操作柜员';
comment on column ${iol_schema}.mpcs_a83cardbinddata.openbrchno is '开户机构';
comment on column ${iol_schema}.mpcs_a83cardbinddata.custaddr is '客户地址';
comment on column ${iol_schema}.mpcs_a83cardbinddata.acctstate is '卡状态 0 正常  2注销 3 挂失 4挂失未激活（网银侧使用）';
comment on column ${iol_schema}.mpcs_a83cardbinddata.qystate is '权益状态 0 正常 1 冻结 2 注销';
comment on column ${iol_schema}.mpcs_a83cardbinddata.opentag is '开卡方式 0-  资产达标 1-  特批开卡';
comment on column ${iol_schema}.mpcs_a83cardbinddata.amtsettag is '管理费收取 0-收管理费 1-一年内免收 2-两年内免收 3-三年内免收 4-终身免费';
comment on column ${iol_schema}.mpcs_a83cardbinddata.amtenddate is '免费终止日期';
comment on column ${iol_schema}.mpcs_a83cardbinddata.accountno is '管理费核算机构 0-总行 1-分行';
comment on column ${iol_schema}.mpcs_a83cardbinddata.remark is '特批说明';
comment on column ${iol_schema}.mpcs_a83cardbinddata.acctamt is '冻结，欠费金额';
comment on column ${iol_schema}.mpcs_a83cardbinddata.acctoperdate is '冻结解冻日期';
comment on column ${iol_schema}.mpcs_a83cardbinddata.acctnochg is '换卡-前映山红卡号';
comment on column ${iol_schema}.mpcs_a83cardbinddata.acctstatechg is '换卡-前映山红卡级别';
comment on column ${iol_schema}.mpcs_a83cardbinddata.amtfeetag is '批量扣收管理费结果状态 0-成功 1-初次批扣失败 2-补扣失败';
comment on column ${iol_schema}.mpcs_a83cardbinddata.acctfreesum is '用户被冻结次数；初始值为0';
comment on column ${iol_schema}.mpcs_a83cardbinddata.transtag is '1 非映山红卡换映山红卡,2 映山红卡换非映山红卡,3 同等级换卡,4 升级换卡 5 降级换卡 6-注销 7-解挂补开 8-管理费标识维护';
comment on column ${iol_schema}.mpcs_a83cardbinddata.dealdate is '操作日期';
comment on column ${iol_schema}.mpcs_a83cardbinddata.remark1 is '';
comment on column ${iol_schema}.mpcs_a83cardbinddata.remark2 is '';
comment on column ${iol_schema}.mpcs_a83cardbinddata.remark3 is '';
comment on column ${iol_schema}.mpcs_a83cardbinddata.remark4 is '';
comment on column ${iol_schema}.mpcs_a83cardbinddata.remark5 is '';
comment on column ${iol_schema}.mpcs_a83cardbinddata.remark6 is '';
comment on column ${iol_schema}.mpcs_a83cardbinddata.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a83cardbinddata.etl_timestamp is 'ETL处理时间戳';
