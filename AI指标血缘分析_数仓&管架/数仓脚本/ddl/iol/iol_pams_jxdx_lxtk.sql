/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_lxtk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_lxtk
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_lxtk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_lxtk(
    jxdxdh number(38,0) -- 绩效对象代号
    ,tjrq number(38,0) -- 统计日期
    ,qdrq number(38,0) -- 渠道日期
    ,sjh varchar2(72) -- 手机号
    ,xnkhh varchar2(135) -- 客户ID（虚拟客户号）
    ,zhdh varchar2(90) -- 账号（卡号）
    ,khh varchar2(72) -- 客户号（内部户）
    ,khjgdh varchar2(51) -- 开户行机构代码
    ,ylkhjylsh varchar2(288) -- 银联开户交易流水号
    ,khrq number(38,0) -- 开户日期
    ,ywlb varchar2(6) -- 业务类别：1-旅行通卡业务；2-福旅通业务
    ,khysms varchar2(6) -- 开户要素模式
    ,zjlx varchar2(288) -- 证件类型
    ,zjh1 varchar2(90) -- 证件号1
    ,zjh2 varchar2(90) -- 证件号2
    ,xing varchar2(450) -- 姓
    ,ming varchar2(450) -- 名
    ,xm varchar2(900) -- 姓名
    ,xb varchar2(6) -- 性别
    ,csrq number(38,0) -- 出生日期
    ,gj varchar2(15) -- 国籍
    ,zy varchar2(24) -- 职业
    ,zyms varchar2(450) -- 职业描述
    ,ssjmsf varchar2(18) -- 税收居民身份
    ,lxdz varchar2(4000) -- 联系地址
    ,sfzjfzrq number(38,0) -- 身份证件发证日期
    ,sfzjyxq number(38,0) -- 身份证件有效期
    ,yyjcjlsh varchar2(180) -- 影印件采集交易的查询流水号
    ,pdm varchar2(27) -- 省代码
    ,cdm varchar2(27) -- 市代码
    ,ddm varchar2(27) -- 区代码
    ,ssn varchar2(18) -- 税收居民国/地区
    ,ssid varchar2(576) -- 居民国/地区纳税人识别号
    ,jjtgyy varchar2(6) -- 不能提供居民国/地区纳税人识别号的原因
    ,jtyy varchar2(450) -- 具体原因
    ,rjqd varchar2(6) -- 入境渠道
    ,xyhyjg varchar2(9) -- 信源核验结果
    ,skqdid varchar2(18) -- 申卡渠道id
    ,skqdmc varchar2(225) -- 申卡渠道名称
    ,khqjlsh varchar2(288) -- 开户全局流水号
    ,zt varchar2(6) -- 状态
    ,zhdj varchar2(6) -- 账户等级
    ,yxq varchar2(54) -- 旅行通卡有效期
    ,xe number(30,4) -- 旅行通卡限额
    ,ljczje number(30,4) -- 累计充值金额
    ,tkzhye number(30,4) -- 退卡账户余额，即退卡账户转清算户交易金额
    ,zxwhrq number(38,0) -- 最新维护时间
    ,jyrq number(38,0) -- 解约日期
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
grant select on ${iol_schema}.pams_jxdx_lxtk to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_lxtk to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_lxtk to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_lxtk to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_lxtk is '旅行通卡账户';
comment on column ${iol_schema}.pams_jxdx_lxtk.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_lxtk.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_lxtk.qdrq is '渠道日期';
comment on column ${iol_schema}.pams_jxdx_lxtk.sjh is '手机号';
comment on column ${iol_schema}.pams_jxdx_lxtk.xnkhh is '客户ID（虚拟客户号）';
comment on column ${iol_schema}.pams_jxdx_lxtk.zhdh is '账号（卡号）';
comment on column ${iol_schema}.pams_jxdx_lxtk.khh is '客户号（内部户）';
comment on column ${iol_schema}.pams_jxdx_lxtk.khjgdh is '开户行机构代码';
comment on column ${iol_schema}.pams_jxdx_lxtk.ylkhjylsh is '银联开户交易流水号';
comment on column ${iol_schema}.pams_jxdx_lxtk.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxdx_lxtk.ywlb is '业务类别：1-旅行通卡业务；2-福旅通业务';
comment on column ${iol_schema}.pams_jxdx_lxtk.khysms is '开户要素模式';
comment on column ${iol_schema}.pams_jxdx_lxtk.zjlx is '证件类型';
comment on column ${iol_schema}.pams_jxdx_lxtk.zjh1 is '证件号1';
comment on column ${iol_schema}.pams_jxdx_lxtk.zjh2 is '证件号2';
comment on column ${iol_schema}.pams_jxdx_lxtk.xing is '姓';
comment on column ${iol_schema}.pams_jxdx_lxtk.ming is '名';
comment on column ${iol_schema}.pams_jxdx_lxtk.xm is '姓名';
comment on column ${iol_schema}.pams_jxdx_lxtk.xb is '性别';
comment on column ${iol_schema}.pams_jxdx_lxtk.csrq is '出生日期';
comment on column ${iol_schema}.pams_jxdx_lxtk.gj is '国籍';
comment on column ${iol_schema}.pams_jxdx_lxtk.zy is '职业';
comment on column ${iol_schema}.pams_jxdx_lxtk.zyms is '职业描述';
comment on column ${iol_schema}.pams_jxdx_lxtk.ssjmsf is '税收居民身份';
comment on column ${iol_schema}.pams_jxdx_lxtk.lxdz is '联系地址';
comment on column ${iol_schema}.pams_jxdx_lxtk.sfzjfzrq is '身份证件发证日期';
comment on column ${iol_schema}.pams_jxdx_lxtk.sfzjyxq is '身份证件有效期';
comment on column ${iol_schema}.pams_jxdx_lxtk.yyjcjlsh is '影印件采集交易的查询流水号';
comment on column ${iol_schema}.pams_jxdx_lxtk.pdm is '省代码';
comment on column ${iol_schema}.pams_jxdx_lxtk.cdm is '市代码';
comment on column ${iol_schema}.pams_jxdx_lxtk.ddm is '区代码';
comment on column ${iol_schema}.pams_jxdx_lxtk.ssn is '税收居民国/地区';
comment on column ${iol_schema}.pams_jxdx_lxtk.ssid is '居民国/地区纳税人识别号';
comment on column ${iol_schema}.pams_jxdx_lxtk.jjtgyy is '不能提供居民国/地区纳税人识别号的原因';
comment on column ${iol_schema}.pams_jxdx_lxtk.jtyy is '具体原因';
comment on column ${iol_schema}.pams_jxdx_lxtk.rjqd is '入境渠道';
comment on column ${iol_schema}.pams_jxdx_lxtk.xyhyjg is '信源核验结果';
comment on column ${iol_schema}.pams_jxdx_lxtk.skqdid is '申卡渠道id';
comment on column ${iol_schema}.pams_jxdx_lxtk.skqdmc is '申卡渠道名称';
comment on column ${iol_schema}.pams_jxdx_lxtk.khqjlsh is '开户全局流水号';
comment on column ${iol_schema}.pams_jxdx_lxtk.zt is '状态';
comment on column ${iol_schema}.pams_jxdx_lxtk.zhdj is '账户等级';
comment on column ${iol_schema}.pams_jxdx_lxtk.yxq is '旅行通卡有效期';
comment on column ${iol_schema}.pams_jxdx_lxtk.xe is '旅行通卡限额';
comment on column ${iol_schema}.pams_jxdx_lxtk.ljczje is '累计充值金额';
comment on column ${iol_schema}.pams_jxdx_lxtk.tkzhye is '退卡账户余额，即退卡账户转清算户交易金额';
comment on column ${iol_schema}.pams_jxdx_lxtk.zxwhrq is '最新维护时间';
comment on column ${iol_schema}.pams_jxdx_lxtk.jyrq is '解约日期';
comment on column ${iol_schema}.pams_jxdx_lxtk.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_lxtk.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_lxtk.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_lxtk.etl_timestamp is 'ETL处理时间戳';
