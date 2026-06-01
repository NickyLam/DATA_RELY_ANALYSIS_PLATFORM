/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ptgetxzkzzhxxinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo(
    transdt varchar2(12) -- 交易日期
    ,transtm varchar2(9) -- 交易时间
    ,uptdttm varchar2(21) -- 更新时间
    ,diskno varchar2(90) -- 批次号
    ,bdhm varchar2(45) -- 控制请求单号
    ,ccxh varchar2(12) -- 序号
    ,khzh varchar2(45) -- 开户账号
    ,cclb varchar2(30) -- 账户类别
    ,khwd varchar2(150) -- 开户网点
    ,khwddm varchar2(30) -- 开户网点代码
    ,bz varchar2(30) -- 申请控制金额币种
    ,kzlx varchar2(12) -- 控制类型 1-存款 2-非存款类金融资产
    ,kzcs varchar2(3) -- 控制措施 01 冻结02 继续冻结 03 轮候冻结 04 解除冻结 05 解除轮候冻结 06 划拨 07 提取收入 08 冻结并划拨
    ,glzhhm varchar2(45) -- 开户账号子账号
    ,zcmc varchar2(60) -- 金融资产名称
    ,zclx varchar2(30) -- 金融资产类型
    ,jldw varchar2(30) -- 计量单位
    ,kznr varchar2(12) -- 申请控制内容 1-账户下的资金 2-账户
    ,ksrq varchar2(29) -- 申请控制开始日期
    ,jsrq varchar2(29) -- 申请控制结束日期
    ,je varchar2(30) -- 申请控制金额
    ,sfjh varchar2(15) -- 是否结汇
    ,ckwh varchar2(75) -- 裁定文书号
    ,zxkzhhm varchar2(150) -- 执行款专户户名
    ,zxkzhkhh varchar2(150) -- 执行款专户开户行
    ,zxkzhkhhhh varchar2(45) -- 执行款专户开户行行号
    ,zxkzhzh varchar2(75) -- 执行款专户账号
    ,zxkzhlx varchar2(30) -- 执行款专户类型
    ,ydjah varchar2(75) -- 原冻结案号
    ,ydjdh varchar2(45) -- 原冻结请求单单号
    ,result varchar2(3) -- 处理状态 0-录入 1-已处理 2-处理失败 3-已登记
    ,cpxszl varchar2(30) -- 产品销售种类
    ,dqh varchar2(45) -- 地区号
    ,jrcpbh varchar2(45) -- 金融产品编号
    ,lczh varchar2(75) -- 理财账号
    ,zjhkzh varchar2(75) -- 资金回款账户
    ,se varchar2(30) -- 申请控制数量/份额/金额
    ,jrkzflag varchar2(2) -- 金融产品冻结标志
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
grant select on ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo is '请求数据控制账户信息表';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.transtm is '交易时间';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.uptdttm is '更新时间';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.diskno is '批次号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.bdhm is '控制请求单号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.ccxh is '序号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.khzh is '开户账号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.cclb is '账户类别';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.khwd is '开户网点';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.khwddm is '开户网点代码';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.bz is '申请控制金额币种';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.kzlx is '控制类型 1-存款 2-非存款类金融资产';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.kzcs is '控制措施 01 冻结02 继续冻结 03 轮候冻结 04 解除冻结 05 解除轮候冻结 06 划拨 07 提取收入 08 冻结并划拨';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.glzhhm is '开户账号子账号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.zcmc is '金融资产名称';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.zclx is '金融资产类型';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.jldw is '计量单位';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.kznr is '申请控制内容 1-账户下的资金 2-账户';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.ksrq is '申请控制开始日期';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.jsrq is '申请控制结束日期';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.je is '申请控制金额';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.sfjh is '是否结汇';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.ckwh is '裁定文书号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.zxkzhhm is '执行款专户户名';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.zxkzhkhh is '执行款专户开户行';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.zxkzhkhhhh is '执行款专户开户行行号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.zxkzhzh is '执行款专户账号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.zxkzhlx is '执行款专户类型';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.ydjah is '原冻结案号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.ydjdh is '原冻结请求单单号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.result is '处理状态 0-录入 1-已处理 2-处理失败 3-已登记';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.cpxszl is '产品销售种类';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.dqh is '地区号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.jrcpbh is '金融产品编号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.lczh is '理财账号';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.zjhkzh is '资金回款账户';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.se is '申请控制数量/份额/金额';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.jrkzflag is '金融产品冻结标志';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo.etl_timestamp is 'ETL处理时间戳';
