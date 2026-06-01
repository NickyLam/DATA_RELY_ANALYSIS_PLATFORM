/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a60projdf_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a60projdf_sign
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a60projdf_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60projdf_sign(
    projno varchar2(15) -- 项目号
    ,projtp varchar2(3) -- 项目名称: 00.代扣 05.代发  09.开卡
    ,acctno varchar2(30) -- 委托单位账号
    ,acctna varchar2(384) -- 委托单位名称
    ,offitl varchar2(30) -- 单位电话
    ,mailad varchar2(150) -- 地址
    ,glacno varchar2(30) -- 内部账户
    ,glacna varchar2(384) -- 内部账户名称
    ,bstype varchar2(2) -- 业务类别 0 普通代发 1 代报帐 2 其他
    ,wdtype varchar2(2) -- 退款方式 0 手工退回 1 自动退回 2 不适用
    ,isnbnk varchar2(2) -- 交易渠道 0 柜台 1 网银 9 全部
    ,compco varchar2(90) -- 组织机构代码
    ,feeamo number(12,2) -- 网银代发手续费
    ,dracno varchar2(27) -- 扣收手续费账号
    ,dracna varchar2(384) -- 手续费账户名称
    ,coyhbl number(12,0) -- 客户优惠率
    ,yhendt varchar2(12) -- 优惠截止日期
    ,signdt varchar2(12) -- 签约日期
    ,cntrbr varchar2(12) -- 签约机构
    ,crtrus varchar2(15) -- 受理柜员
    ,modidt varchar2(12) -- 修改日期
    ,mdtrbr varchar2(9) -- 修改机构
    ,mdtrus varchar2(15) -- 修改柜员
    ,cntrst varchar2(2) -- 协议状态  1-正常0-关闭
    ,closdt varchar2(12) -- 解约日期
    ,closus varchar2(15) -- 解约柜员
    ,custno varchar2(30) -- 客户号
    ,otherflag varchar2(2) -- 他行标识 0-本行 1-他行
    ,otheracctno varchar2(90) -- 他行账号
    ,otheracctna varchar2(384) -- 他行户名
    ,otherbankno varchar2(21) -- 他行行号
    ,otherbankna varchar2(180) -- 他行行名
    ,inneracno varchar2(30) -- 过渡内部户账号
    ,inneracna varchar2(384) -- 过渡内部户户名
    ,tkflag varchar2(2) -- 退款标志
    ,lmtamtflg varchar2(2) -- 限额类型：1-全局限额 2-客户自定义月累计限额
    ,monthlmtamt varchar2(30) -- 月累计限额
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
grant select on ${iol_schema}.mpcs_a60projdf_sign to ${iml_schema};
grant select on ${iol_schema}.mpcs_a60projdf_sign to ${icl_schema};
grant select on ${iol_schema}.mpcs_a60projdf_sign to ${idl_schema};
grant select on ${iol_schema}.mpcs_a60projdf_sign to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a60projdf_sign is '签约表';
comment on column ${iol_schema}.mpcs_a60projdf_sign.projno is '项目号';
comment on column ${iol_schema}.mpcs_a60projdf_sign.projtp is '项目名称: 00.代扣 05.代发  09.开卡';
comment on column ${iol_schema}.mpcs_a60projdf_sign.acctno is '委托单位账号';
comment on column ${iol_schema}.mpcs_a60projdf_sign.acctna is '委托单位名称';
comment on column ${iol_schema}.mpcs_a60projdf_sign.offitl is '单位电话';
comment on column ${iol_schema}.mpcs_a60projdf_sign.mailad is '地址';
comment on column ${iol_schema}.mpcs_a60projdf_sign.glacno is '内部账户';
comment on column ${iol_schema}.mpcs_a60projdf_sign.glacna is '内部账户名称';
comment on column ${iol_schema}.mpcs_a60projdf_sign.bstype is '业务类别 0 普通代发 1 代报帐 2 其他';
comment on column ${iol_schema}.mpcs_a60projdf_sign.wdtype is '退款方式 0 手工退回 1 自动退回 2 不适用';
comment on column ${iol_schema}.mpcs_a60projdf_sign.isnbnk is '交易渠道 0 柜台 1 网银 9 全部';
comment on column ${iol_schema}.mpcs_a60projdf_sign.compco is '组织机构代码';
comment on column ${iol_schema}.mpcs_a60projdf_sign.feeamo is '网银代发手续费';
comment on column ${iol_schema}.mpcs_a60projdf_sign.dracno is '扣收手续费账号';
comment on column ${iol_schema}.mpcs_a60projdf_sign.dracna is '手续费账户名称';
comment on column ${iol_schema}.mpcs_a60projdf_sign.coyhbl is '客户优惠率';
comment on column ${iol_schema}.mpcs_a60projdf_sign.yhendt is '优惠截止日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign.signdt is '签约日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign.cntrbr is '签约机构';
comment on column ${iol_schema}.mpcs_a60projdf_sign.crtrus is '受理柜员';
comment on column ${iol_schema}.mpcs_a60projdf_sign.modidt is '修改日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign.mdtrbr is '修改机构';
comment on column ${iol_schema}.mpcs_a60projdf_sign.mdtrus is '修改柜员';
comment on column ${iol_schema}.mpcs_a60projdf_sign.cntrst is '协议状态  1-正常0-关闭';
comment on column ${iol_schema}.mpcs_a60projdf_sign.closdt is '解约日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign.closus is '解约柜员';
comment on column ${iol_schema}.mpcs_a60projdf_sign.custno is '客户号';
comment on column ${iol_schema}.mpcs_a60projdf_sign.otherflag is '他行标识 0-本行 1-他行';
comment on column ${iol_schema}.mpcs_a60projdf_sign.otheracctno is '他行账号';
comment on column ${iol_schema}.mpcs_a60projdf_sign.otheracctna is '他行户名';
comment on column ${iol_schema}.mpcs_a60projdf_sign.otherbankno is '他行行号';
comment on column ${iol_schema}.mpcs_a60projdf_sign.otherbankna is '他行行名';
comment on column ${iol_schema}.mpcs_a60projdf_sign.inneracno is '过渡内部户账号';
comment on column ${iol_schema}.mpcs_a60projdf_sign.inneracna is '过渡内部户户名';
comment on column ${iol_schema}.mpcs_a60projdf_sign.tkflag is '退款标志';
comment on column ${iol_schema}.mpcs_a60projdf_sign.lmtamtflg is '限额类型：1-全局限额 2-客户自定义月累计限额';
comment on column ${iol_schema}.mpcs_a60projdf_sign.monthlmtamt is '月累计限额';
comment on column ${iol_schema}.mpcs_a60projdf_sign.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a60projdf_sign.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a60projdf_sign.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a60projdf_sign.etl_timestamp is 'ETL处理时间戳';
