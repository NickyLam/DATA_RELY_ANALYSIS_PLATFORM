/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zjywzcmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zjywzcmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zjywzcmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zjywzcmx(
    tjrq number(22) -- 数据日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,gsjgdxdh number(22) -- 管护机构对象代号
    ,gsjgdh varchar2(135) -- 管护机构代号
    ,gsjgmc varchar2(135) -- 管护机构名称
    ,zwjgdxdh number(22) -- 归属机构对象代号
    ,zwjgdh varchar2(135) -- 账务机构编号
    ,zwjgmc varchar2(135) -- 归属机构名称
    ,khlx varchar2(15) -- 客户类型
    ,jylsh varchar2(135) -- 交易流水号
    ,qjlsh varchar2(225) -- 全局流水号
    ,ywlsh varchar2(225) -- 业务流水号
    ,sfdjh varchar2(225) -- 收费单据号
    ,sflsh varchar2(225) -- 收费流水号
    ,sfrq number(22) -- 收费日期
    ,jsrq number(22) -- 交易日期
    ,zwrq number(22) -- 账务日期
    ,txbz varchar2(23) -- 摊销标志
    ,txlsh varchar2(135) -- 摊销流水号
    ,txksrq number(22) -- 摊销开始日期
    ,txjsrq number(22) -- 摊销结束日期
    ,ljtxje number(30,2) -- 累计摊销金额
    ,dtze number(30,2) -- 待摊总金额
    ,jyje number(30,2) -- 交易金额
    ,bz varchar2(23) -- 币种代码
    ,kmh varchar2(135) -- 科目编号
    ,kmmc varchar2(563) -- 科目名称
    ,bzcpbh varchar2(135) -- 标准产品编号
    ,khh varchar2(135) -- 客户编号
    ,khmc varchar2(563) -- 客户名称
    ,khgstxlxdm varchar2(45) -- 客户归属条线类型代码
    ,jyjgdh varchar2(135) -- 交易机构代号
    ,jyjgdxdh number(22) -- 交易机构对象代号
    ,jyjgmc varchar2(135) -- 交易机构名称
    ,jyzhbh varchar2(135) -- 交易账户编号
    ,jyzzhbh varchar2(135) -- 交易主账户编号
    ,jyczhbh varchar2(135) -- 交易子账户编号
    ,jyqddm varchar2(135) -- 交易渠道代码
    ,yxtdm varchar2(135) -- 源系统代码
    ,hydh varchar2(135) -- 客户经理编号
    ,hymc varchar2(135) -- 行员名称
    ,sffsdm varchar2(23) -- 收费方式代码
    ,sxfzqfs varchar2(23) -- 手续费收取方式
    ,jylxdm varchar2(23) -- 交易类型代码
    ,jdbz varchar2(23) -- 借贷标志
    ,mzbz varchar2(23) -- 抹账标志
    ,czbz varchar2(23) -- 冲正标志
    ,xjjybz varchar2(225) -- 现金交易标志
    ,etl_t varchar2(90) -- ETL处理时间戳
    ,ywzhbh varchar2(90) -- 业务账户编号
    ,ybbz varchar2(15) -- 原表币种
    ,jyjeylj number(30,2) -- 交易金额月累计
    ,jyjejlj number(30,2) -- 交易金额季累计
    ,jyjenlj number(30,2) -- 交易金额年累计
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
grant select on ${iol_schema}.pams_jxbb_zjywzcmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zjywzcmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zjywzcmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zjywzcmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zjywzcmx is '绩效对象_中间业务支出明细表';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.tjrq is '数据日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.gsjgdxdh is '管护机构对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.gsjgdh is '管护机构代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.gsjgmc is '管护机构名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.zwjgdxdh is '归属机构对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.zwjgdh is '账务机构编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.zwjgmc is '归属机构名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.khlx is '客户类型';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jylsh is '交易流水号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.qjlsh is '全局流水号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.ywlsh is '业务流水号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.sfdjh is '收费单据号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.sflsh is '收费流水号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.sfrq is '收费日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jsrq is '交易日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.zwrq is '账务日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.txbz is '摊销标志';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.txlsh is '摊销流水号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.txksrq is '摊销开始日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.txjsrq is '摊销结束日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.ljtxje is '累计摊销金额';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.dtze is '待摊总金额';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyje is '交易金额';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.bz is '币种代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.kmh is '科目编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.bzcpbh is '标准产品编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.khh is '客户编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.khgstxlxdm is '客户归属条线类型代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyjgdh is '交易机构代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyjgdxdh is '交易机构对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyjgmc is '交易机构名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyzhbh is '交易账户编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyzzhbh is '交易主账户编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyczhbh is '交易子账户编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyqddm is '交易渠道代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.yxtdm is '源系统代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.hydh is '客户经理编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.sffsdm is '收费方式代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.sxfzqfs is '手续费收取方式';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jylxdm is '交易类型代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jdbz is '借贷标志';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.mzbz is '抹账标志';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.czbz is '冲正标志';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.xjjybz is '现金交易标志';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.etl_t is 'ETL处理时间戳';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.ywzhbh is '业务账户编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.ybbz is '原表币种';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyjeylj is '交易金额月累计';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyjejlj is '交易金额季累计';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.jyjenlj is '交易金额年累计';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx.etl_timestamp is 'ETL处理时间戳';
