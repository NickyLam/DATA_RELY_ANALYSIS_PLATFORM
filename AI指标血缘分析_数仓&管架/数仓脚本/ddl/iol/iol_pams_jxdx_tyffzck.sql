/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_tyffzck
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_tyffzck
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_tyffzck purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_tyffzck(
    jxdxdh number(22,0) -- 绩效对象代号
    ,ywbh varchar2(45) -- 业务编号
    ,wbbh varchar2(45) -- 外部账户编号
    ,nbbh varchar2(45) -- 内部账户编号
    ,zclxbh varchar2(45) -- 资产类型编号
    ,sclxbh varchar2(45) -- 市场类型编号
    ,jrgjdm varchar2(450) -- 金融工具代码
    ,jrgjmc varchar2(150) -- 金融工具名称
    ,kjfl varchar2(30) -- 会计分类
    ,cplx varchar2(150) -- 产品类型
    ,jyssjgdh varchar2(30) -- 交易所属机构
    ,jyrq number(22,0) -- 交易日期
    ,jydskhh varchar2(45) -- 交易对手客户号
    ,jyds varchar2(150) -- 交易对手
    ,jydslx varchar2(150) -- 交易对手客户分类
    ,sjrzrkhh varchar2(45) -- 发行人/实际融资人客户号
    ,sjrzr varchar2(150) -- 发行人/实际融资人
    ,sjrzrlx varchar2(150) -- 实际融资人客户分类
    ,bz varchar2(5) -- 币种
    ,tzbj number(25,4) -- 投资本金(元)
    ,zxll number(15,7) -- 执行利率
    ,qxr number(22,0) -- 起息日
    ,dqr number(22,0) -- 到期日期
    ,scfxrq number(22,0) -- 首次付息日期
    ,fxpl varchar2(150) -- 付息频率
    ,jxjz varchar2(90) -- 计息基准
    ,tzye number(25,4) -- 投资余额
    ,zmye number(25,4) -- 账面余额
    ,bjkmh varchar2(45) -- 本金科目号
    ,ftpll number(15,7) -- 准备金ftp利率
    ,gxhslx varchar2(2) -- 关系函数类型
    ,khdxdh number(22,0) -- 考核对象代号
    ,tjrq number(22,0) -- 统计日期
    ,xplx varchar2(15) -- 息票类型
    ,sjly varchar2(3) -- 数据来源
    ,czcdm varchar2(90) -- 次资产代码
    ,ywlbmc varchar2(150) -- 业务类别名称
    ,zclbmc varchar2(375) -- 资产类别名称
    ,jjcf varchar2(150) -- 经济成分
    ,txhy varchar2(150) -- 投向行业
    ,ssdq varchar2(150) -- 所属地区
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
grant select on ${iol_schema}.pams_jxdx_tyffzck to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_tyffzck to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_tyffzck to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_tyffzck to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_tyffzck is '绩效对象_同业存款子账户';
comment on column ${iol_schema}.pams_jxdx_tyffzck.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_tyffzck.ywbh is '业务编号';
comment on column ${iol_schema}.pams_jxdx_tyffzck.wbbh is '外部账户编号';
comment on column ${iol_schema}.pams_jxdx_tyffzck.nbbh is '内部账户编号';
comment on column ${iol_schema}.pams_jxdx_tyffzck.zclxbh is '资产类型编号';
comment on column ${iol_schema}.pams_jxdx_tyffzck.sclxbh is '市场类型编号';
comment on column ${iol_schema}.pams_jxdx_tyffzck.jrgjdm is '金融工具代码';
comment on column ${iol_schema}.pams_jxdx_tyffzck.jrgjmc is '金融工具名称';
comment on column ${iol_schema}.pams_jxdx_tyffzck.kjfl is '会计分类';
comment on column ${iol_schema}.pams_jxdx_tyffzck.cplx is '产品类型';
comment on column ${iol_schema}.pams_jxdx_tyffzck.jyssjgdh is '交易所属机构';
comment on column ${iol_schema}.pams_jxdx_tyffzck.jyrq is '交易日期';
comment on column ${iol_schema}.pams_jxdx_tyffzck.jydskhh is '交易对手客户号';
comment on column ${iol_schema}.pams_jxdx_tyffzck.jyds is '交易对手';
comment on column ${iol_schema}.pams_jxdx_tyffzck.jydslx is '交易对手客户分类';
comment on column ${iol_schema}.pams_jxdx_tyffzck.sjrzrkhh is '发行人/实际融资人客户号';
comment on column ${iol_schema}.pams_jxdx_tyffzck.sjrzr is '发行人/实际融资人';
comment on column ${iol_schema}.pams_jxdx_tyffzck.sjrzrlx is '实际融资人客户分类';
comment on column ${iol_schema}.pams_jxdx_tyffzck.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_tyffzck.tzbj is '投资本金(元)';
comment on column ${iol_schema}.pams_jxdx_tyffzck.zxll is '执行利率';
comment on column ${iol_schema}.pams_jxdx_tyffzck.qxr is '起息日';
comment on column ${iol_schema}.pams_jxdx_tyffzck.dqr is '到期日期';
comment on column ${iol_schema}.pams_jxdx_tyffzck.scfxrq is '首次付息日期';
comment on column ${iol_schema}.pams_jxdx_tyffzck.fxpl is '付息频率';
comment on column ${iol_schema}.pams_jxdx_tyffzck.jxjz is '计息基准';
comment on column ${iol_schema}.pams_jxdx_tyffzck.tzye is '投资余额';
comment on column ${iol_schema}.pams_jxdx_tyffzck.zmye is '账面余额';
comment on column ${iol_schema}.pams_jxdx_tyffzck.bjkmh is '本金科目号';
comment on column ${iol_schema}.pams_jxdx_tyffzck.ftpll is '准备金ftp利率';
comment on column ${iol_schema}.pams_jxdx_tyffzck.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_tyffzck.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_tyffzck.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_tyffzck.xplx is '息票类型';
comment on column ${iol_schema}.pams_jxdx_tyffzck.sjly is '数据来源';
comment on column ${iol_schema}.pams_jxdx_tyffzck.czcdm is '次资产代码';
comment on column ${iol_schema}.pams_jxdx_tyffzck.ywlbmc is '业务类别名称';
comment on column ${iol_schema}.pams_jxdx_tyffzck.zclbmc is '资产类别名称';
comment on column ${iol_schema}.pams_jxdx_tyffzck.jjcf is '经济成分';
comment on column ${iol_schema}.pams_jxdx_tyffzck.txhy is '投向行业';
comment on column ${iol_schema}.pams_jxdx_tyffzck.ssdq is '所属地区';
comment on column ${iol_schema}.pams_jxdx_tyffzck.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_tyffzck.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_tyffzck.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_tyffzck.etl_timestamp is 'ETL处理时间戳';
