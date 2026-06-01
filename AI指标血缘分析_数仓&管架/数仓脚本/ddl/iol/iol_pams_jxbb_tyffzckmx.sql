/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_tyffzckmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_tyffzckmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_tyffzckmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_tyffzckmx(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,ywbh varchar2(90) -- 业务编号
    ,jrgjdm varchar2(900) -- 金融工具代码
    ,jrgjmc varchar2(300) -- 金融工具名称
    ,jyssjgdh varchar2(30) -- 交易所属机构
    ,jgmc varchar2(300) -- 机构名称
    ,kjfl varchar2(90) -- 会计分类
    ,cplx varchar2(300) -- 产品类型
    ,jyrq number(22,0) -- 交易日期
    ,jydskhh varchar2(90) -- 交易对手客户号
    ,jyds varchar2(300) -- 交易对手
    ,jydslx varchar2(30) -- 交易对手客户分类
    ,sjrzrkhh varchar2(90) -- 发行人/实际融资人客户号
    ,sjrzr varchar2(300) -- 发行人/实际融资人
    ,sjrzrlx varchar2(30) -- 实际融资人客户分类
    ,bz varchar2(1500) -- 币种
    ,tzbj number(25,4) -- 投资本金(元)
    ,zxll number(15,7) -- 执行利率
    ,qxr number(22,0) -- 起息日
    ,dqr number(22,0) -- 到期日期
    ,scfxrq number(22,0) -- 首次付息日期
    ,fxpl varchar2(300) -- 付息频率
    ,jxjz varchar2(180) -- 计息基准
    ,tzye number(25,4) -- 投资余额
    ,zmye number(25,4) -- 账面余额
    ,dqgyjgbdsy number(25,4) -- 当前公允价值变动损益
    ,drlxsr number(25,4) -- 当日利息收入
    ,dylxsr number(25,4) -- 当月利息收入
    ,bnlxsr number(25,4) -- 本年利息收入(元)
    ,ljlxsr number(25,4) -- 累计利息收入
    ,drlxzc number(25,4) -- 当日利息支出(元)
    ,dylxzc number(25,4) -- 当月利息支出
    ,djlxzc number(25,4) -- 当季利息支出
    ,dnlxzc number(25,4) -- 本年利息支出(元)
    ,lxsrzzs number(25,4) -- 利息收入增值税(元),
    ,bnmmsy number(25,4) -- 半年买卖损益
    ,ljmmsy number(25,4) -- 累计买卖损益
    ,yzbwlx number(25,4) -- 已转表外利息(元)
    ,bjkmh varchar2(90) -- 本金科目号
    ,bjkmmc varchar2(300) -- 本金科目名称
    ,ftpll number(15,7) -- 准备金ftp利率
    ,zhnrjye number(25,4) -- 账户年日均余额
    ,zhjrjye number(25,4) -- 账户季日均余额
    ,zhyrjye number(25,4) -- 账户月日均余额
    ,fphyrj number(25,4) -- 分配后月日均
    ,fphjrj number(25,4) -- 分配后季日均
    ,fphnrj number(25,4) -- 分配后年日均
    ,zjsr number(25,4) -- 中间收入
    ,ftpsyrlj number(25,4) -- ftp收益日累计
    ,ftpsyylj number(25,4) -- ftp收益月累计
    ,ftpsynlj number(25,4) -- ftp收益年累计
    ,ftpsyljlj number(25,4) -- ftp收益累计累计
    ,fpjs varchar2(6) -- 分配角色
    ,khdxdh number(22,0) -- 考核对象代号
    ,zlbl number(15,2) -- 增量比例
    ,xplx varchar2(30) -- 息票类型
    ,jydslxms varchar2(900) -- 交易对手类型描述
    ,sjrzrlxms varchar2(900) -- 事件rzrlxms
    ,jxjzms varchar2(900) -- 结息基准描述
    ,cplxmc varchar2(300) -- 产品类型名称
    ,tzid varchar2(60) -- 投组id
    ,sjly varchar2(180) -- 数据来源
    ,hydh varchar2(30) -- 行员代号
    ,hymc varchar2(75) -- 行员名称
    ,ssjgdh varchar2(30) -- 机构代号
    ,fptx varchar2(15) -- 所属条线
    ,txfpbl number(19,5) -- 条线分配比例
    ,ssjgmc varchar2(75) -- 机构名称
    ,hsfxjqzcje number(25,4) -- 缓释后的风险加权资产金额
    ,tzsy number(22,4) -- 调整收益
    ,tzsyylj number(22,4) -- 调整收益月累计
    ,tzsyjlj number(22,4) -- 调整收益季累计
    ,tzsynlj number(22,4) -- 调整收益年累计
    ,blqtzsy number(22,4) -- 补录前调整收益
    ,blqtzsyylj number(22,4) -- 补录前调整收益月累计
    ,blqtzsyjlj number(22,4) -- 补录前调整收益季累计
    ,blqtzsynlj number(22,4) -- 补录前调整收益年累计
    ,blsyje number(22,4) -- 补录收益金额
    ,blsyjeylj number(22,4) -- 补录收益金额月累计
    ,blsyjejlj number(22,4) -- 补录收益金额季累计
    ,blsyjenlj number(22,4) -- 补录收益金额年累计
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,ljtzysje number(25,4) -- 累计调整营收金额
    ,tzhljftpjsy number(25,4) -- 调整后累计ftp净收益
    ,ljtzfyje number(25,4) -- 累计调整费用金额
    ,jjljftpjsy number(25,4) -- 计奖累计ftp净收益
    ,dytzysje number(25,4) -- 月累计调整营收金额
    ,tzhdyftpjsy number(25,4) -- 调整后月累计ftp净收益
    ,dytzfyje number(25,4) -- 月累计调整费用金额
    ,jjdyftpjsy number(25,4) -- 计奖月累计ftp净收益
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
grant select on ${iol_schema}.pams_jxbb_tyffzckmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_tyffzckmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_tyffzckmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_tyffzckmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_tyffzckmx is '绩效报表_同业投融资明细';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ywbh is '业务编号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jrgjdm is '金融工具代码';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jrgjmc is '金融工具名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jyssjgdh is '交易所属机构';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.kjfl is '会计分类';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.cplx is '产品类型';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jyrq is '交易日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jydskhh is '交易对手客户号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jyds is '交易对手';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jydslx is '交易对手客户分类';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.sjrzrkhh is '发行人/实际融资人客户号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.sjrzr is '发行人/实际融资人';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.sjrzrlx is '实际融资人客户分类';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.tzbj is '投资本金(元)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.zxll is '执行利率';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.qxr is '起息日';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.dqr is '到期日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.scfxrq is '首次付息日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.fxpl is '付息频率';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jxjz is '计息基准';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.tzye is '投资余额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.zmye is '账面余额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.dqgyjgbdsy is '当前公允价值变动损益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.drlxsr is '当日利息收入';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.dylxsr is '当月利息收入';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.bnlxsr is '本年利息收入(元)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ljlxsr is '累计利息收入';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.drlxzc is '当日利息支出(元)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.dylxzc is '当月利息支出';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.djlxzc is '当季利息支出';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.dnlxzc is '本年利息支出(元)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.lxsrzzs is '利息收入增值税(元),';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.bnmmsy is '半年买卖损益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ljmmsy is '累计买卖损益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.yzbwlx is '已转表外利息(元)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.bjkmh is '本金科目号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.bjkmmc is '本金科目名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ftpll is '准备金ftp利率';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.zhnrjye is '账户年日均余额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.zhjrjye is '账户季日均余额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.zhyrjye is '账户月日均余额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.fphyrj is '分配后月日均';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.fphjrj is '分配后季日均';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.fphnrj is '分配后年日均';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.zjsr is '中间收入';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ftpsyrlj is 'ftp收益日累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ftpsyylj is 'ftp收益月累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ftpsynlj is 'ftp收益年累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ftpsyljlj is 'ftp收益累计累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.xplx is '息票类型';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jydslxms is '交易对手类型描述';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.sjrzrlxms is '事件rzrlxms';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jxjzms is '结息基准描述';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.cplxmc is '产品类型名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.tzid is '投组id';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.sjly is '数据来源';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ssjgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.fptx is '所属条线';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ssjgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.hsfxjqzcje is '缓释后的风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.tzsy is '调整收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.tzsyylj is '调整收益月累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.tzsyjlj is '调整收益季累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.tzsynlj is '调整收益年累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.blqtzsy is '补录前调整收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.blqtzsyylj is '补录前调整收益月累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.blqtzsyjlj is '补录前调整收益季累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.blqtzsynlj is '补录前调整收益年累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.blsyje is '补录收益金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.blsyjeylj is '补录收益金额月累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.blsyjejlj is '补录收益金额季累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.blsyjenlj is '补录收益金额年累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ljtzysje is '累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.tzhljftpjsy is '调整后累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.ljtzfyje is '累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jjljftpjsy is '计奖累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.dytzysje is '月累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.tzhdyftpjsy is '调整后月累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.dytzfyje is '月累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.jjdyftpjsy is '计奖月累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx.etl_timestamp is 'ETL处理时间戳';
