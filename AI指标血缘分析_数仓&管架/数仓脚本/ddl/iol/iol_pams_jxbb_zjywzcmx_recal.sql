/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zjywzcmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zjywzcmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zjywzcmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zjywzcmx_recal(
    tjrq number(22) -- 统计日期
    ,recal_dt number(22) -- 重算日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,gsjgdxdh number(22) -- 归属机构对象代号
    ,gsjgdh varchar2(270) -- 归属机构代号
    ,gsjgmc varchar2(270) -- 归属机构名称
    ,zwjgdxdh number(22) -- 账务机构对象代号
    ,zwjgdh varchar2(270) -- 账务机构编号
    ,zwjgmc varchar2(270) -- 账务机构名称
    ,khlx varchar2(30) -- 客户类型
    ,jylsh varchar2(270) -- 交易流水号
    ,qjlsh varchar2(450) -- 全局流水号
    ,ywlsh varchar2(450) -- 业务流水号
    ,sfdjh varchar2(450) -- 收费单据号
    ,sflsh varchar2(450) -- 收费流水号
    ,sfrq number(22) -- 收费日期
    ,jsrq number(22) -- 交易日期
    ,zwrq number(22) -- 账务日期
    ,txbz varchar2(45) -- 摊销标志
    ,txlsh varchar2(270) -- 摊销流水号
    ,txksrq number(22) -- 摊销开始日期
    ,txjsrq number(22) -- 摊销结束日期
    ,ljtxje number(30,2) -- 累计摊销金额
    ,dtze number(30,2) -- 待摊总金额
    ,jyje number(30,2) -- 交易金额
    ,bz varchar2(45) -- 币种
    ,kmh varchar2(270) -- 科目号
    ,kmmc varchar2(1125) -- 科目名称
    ,bzcpbh varchar2(270) -- 标准产品编号
    ,khh varchar2(270) -- 客户号
    ,khmc varchar2(1125) -- 客户名称
    ,khgstxlxdm varchar2(90) -- 客户归属条线类型代码
    ,jyjgdh varchar2(270) -- 交易机构代号
    ,jyjgdxdh number(22) -- 交易机构对象代号
    ,jyjgmc varchar2(270) -- 交易机构名称
    ,jyzhbh varchar2(270) -- 交易账户编号
    ,jyzzhbh varchar2(270) -- 交易主账户编号
    ,jyczhbh varchar2(270) -- 交易子账户编号
    ,jyqddm varchar2(270) -- 交易渠道代码
    ,yxtdm varchar2(270) -- 源系统代码
    ,hydh varchar2(270) -- 客户经理编号
    ,hymc varchar2(270) -- 行员名称
    ,sffsdm varchar2(45) -- 收费方式代码
    ,sxfzqfs varchar2(45) -- 手续费收取方式
    ,jylxdm varchar2(45) -- 交易类型代码
    ,jdbz varchar2(45) -- 借贷标志
    ,mzbz varchar2(45) -- 抹账标志
    ,czbz varchar2(45) -- 冲正标志
    ,xjjybz varchar2(450) -- 现金交易标志
    ,etl_t varchar2(180) -- ETL处理时间戳
    ,ywzhbh varchar2(180) -- 业务账户编号
    ,ybbz varchar2(30) -- 原表币种
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
grant select on ${iol_schema}.pams_jxbb_zjywzcmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zjywzcmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zjywzcmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zjywzcmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zjywzcmx_recal is '绩效对象_中间业务支出明细表_重算';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.gsjgdxdh is '归属机构对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.gsjgdh is '归属机构代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.gsjgmc is '归属机构名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.zwjgdxdh is '账务机构对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.zwjgdh is '账务机构编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.zwjgmc is '账务机构名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.khlx is '客户类型';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jylsh is '交易流水号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.qjlsh is '全局流水号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.ywlsh is '业务流水号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.sfdjh is '收费单据号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.sflsh is '收费流水号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.sfrq is '收费日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jsrq is '交易日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.zwrq is '账务日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.txbz is '摊销标志';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.txlsh is '摊销流水号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.txksrq is '摊销开始日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.txjsrq is '摊销结束日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.ljtxje is '累计摊销金额';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.dtze is '待摊总金额';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyje is '交易金额';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.bzcpbh is '标准产品编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.khgstxlxdm is '客户归属条线类型代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyjgdh is '交易机构代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyjgdxdh is '交易机构对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyjgmc is '交易机构名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyzhbh is '交易账户编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyzzhbh is '交易主账户编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyczhbh is '交易子账户编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyqddm is '交易渠道代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.yxtdm is '源系统代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.hydh is '客户经理编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.sffsdm is '收费方式代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.sxfzqfs is '手续费收取方式';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jylxdm is '交易类型代码';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jdbz is '借贷标志';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.mzbz is '抹账标志';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.czbz is '冲正标志';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.xjjybz is '现金交易标志';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.etl_t is 'ETL处理时间戳';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.ywzhbh is '业务账户编号';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.ybbz is '原表币种';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyjeylj is '交易金额月累计';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyjejlj is '交易金额季累计';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.jyjenlj is '交易金额年累计';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_zjywzcmx_recal.etl_timestamp is 'ETL处理时间戳';
