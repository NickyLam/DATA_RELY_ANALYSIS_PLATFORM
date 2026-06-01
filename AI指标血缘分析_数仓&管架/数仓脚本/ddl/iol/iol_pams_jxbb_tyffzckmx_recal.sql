/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_tyffzckmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_tyffzckmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_tyffzckmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_tyffzckmx_recal(
    tjrq number(22) -- 数据入库日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,ywbh varchar2(90) -- 业务编号
    ,jrgjdm varchar2(900) -- 金融工具代码
    ,jrgjmc varchar2(300) -- 金融工具名称
    ,jyssjgdh varchar2(30) -- 交易所属机构
    ,jgmc varchar2(300) -- 机构名称
    ,kjfl varchar2(90) -- 会计分类
    ,cplx varchar2(300) -- 签约产品类型
    ,jyrq number(22) -- 交易日期
    ,jydskhh varchar2(90) -- 交易对手客户号
    ,jyds varchar2(300) -- 交易对手
    ,jydslx varchar2(30) -- 交易对手客户分类
    ,sjrzrkhh varchar2(90) -- 发行人/实际融资人客户号
    ,sjrzr varchar2(300) -- 发行人/实际融资人
    ,sjrzrlx varchar2(30) -- 实际融资人客户分类
    ,bz varchar2(1500) -- 币种
    ,tzbj number(25,4) -- 投资本金(元)
    ,zxll number(15,7) -- 执行利率/参考收益率(%)
    ,qxr number(22) -- 起息日
    ,dqr number(22) -- 到期日期
    ,scfxrq number(22) -- 首次付息日期
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
    ,lxsrzzs number(25,4) -- 税额
    ,bnmmsy number(25,4) -- 半年买卖损益
    ,ljmmsy number(25,4) -- 累计买卖损益
    ,yzbwlx number(25,4) -- 已转表外利息
    ,bjkmh varchar2(90) -- 本金科目号
    ,bjkmmc varchar2(300) -- 本金科目名称
    ,ftpll number(15,7) -- 准备金FTP利率
    ,zhnrjye number(25,4) -- 年日均
    ,zhjrjye number(25,4) -- 账户季日均
    ,zhyrjye number(25,4) -- 账户月日均
    ,fphyrj number(25,4) -- 分配后月日均
    ,fphjrj number(25,4) -- 分配后季日均
    ,fphnrj number(25,4) -- 分配后年日均
    ,zjsr number(25,4) -- 净收入
    ,ftpsyrlj number(25,4) -- ftp收益日累计
    ,ftpsyylj number(25,4) -- FTP收益月累计
    ,ftpsynlj number(25,4) -- ftp净收入(年累计)
    ,ftpsyljlj number(25,4) -- FTP收益累计累计
    ,fpjs varchar2(6) -- 分配角色
    ,khdxdh number(22) -- 行员考核对象代号
    ,zlbl number(15,2) -- 认领比例
    ,xplx varchar2(30) -- 息票类型
    ,jydslxms varchar2(900) -- 交易对手类型描述
    ,sjrzrlxms varchar2(900) -- 事件RZRLXMS
    ,jxjzms varchar2(900) -- 结息基准描述
    ,cplxmc varchar2(300) -- 产品类型名称
    ,sjly varchar2(180) -- 数据来源
    ,tzid varchar2(60) -- 投组id
    ,hydh varchar2(60) -- 行员代号
    ,hymc varchar2(150) -- 行员名称
    ,ssjgdh varchar2(60) -- 机构代号
    ,ssjgmc varchar2(150) -- 所属机构名称
    ,fptx varchar2(30) -- 所属条线
    ,txfpbl number(19,5) -- 条线分配比例
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
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_tyffzckmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_tyffzckmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_tyffzckmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_tyffzckmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_tyffzckmx_recal is '绩效报表_同业投融资明细_重算';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.tjrq is '数据入库日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ywbh is '业务编号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jrgjdm is '金融工具代码';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jrgjmc is '金融工具名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jyssjgdh is '交易所属机构';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.kjfl is '会计分类';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.cplx is '签约产品类型';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jyrq is '交易日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jydskhh is '交易对手客户号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jyds is '交易对手';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jydslx is '交易对手客户分类';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.sjrzrkhh is '发行人/实际融资人客户号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.sjrzr is '发行人/实际融资人';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.sjrzrlx is '实际融资人客户分类';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.tzbj is '投资本金(元)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.zxll is '执行利率/参考收益率(%)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.qxr is '起息日';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.dqr is '到期日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.scfxrq is '首次付息日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.fxpl is '付息频率';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jxjz is '计息基准';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.tzye is '投资余额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.zmye is '账面余额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.dqgyjgbdsy is '当前公允价值变动损益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.drlxsr is '当日利息收入';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.dylxsr is '当月利息收入';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.bnlxsr is '本年利息收入(元)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ljlxsr is '累计利息收入';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.drlxzc is '当日利息支出(元)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.dylxzc is '当月利息支出';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.djlxzc is '当季利息支出';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.dnlxzc is '本年利息支出(元)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.lxsrzzs is '税额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.bnmmsy is '半年买卖损益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ljmmsy is '累计买卖损益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.yzbwlx is '已转表外利息';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.bjkmh is '本金科目号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.bjkmmc is '本金科目名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ftpll is '准备金FTP利率';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.zhnrjye is '年日均';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.zhjrjye is '账户季日均';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.zhyrjye is '账户月日均';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.fphyrj is '分配后月日均';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.fphjrj is '分配后季日均';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.fphnrj is '分配后年日均';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.zjsr is '净收入';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ftpsyrlj is 'ftp收益日累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ftpsyylj is 'FTP收益月累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ftpsynlj is 'ftp净收入(年累计)';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ftpsyljlj is 'FTP收益累计累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.khdxdh is '行员考核对象代号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.xplx is '息票类型';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jydslxms is '交易对手类型描述';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.sjrzrlxms is '事件RZRLXMS';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jxjzms is '结息基准描述';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.cplxmc is '产品类型名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.sjly is '数据来源';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.tzid is '投组id';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ssjgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.fptx is '所属条线';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.hsfxjqzcje is '缓释后的风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.tzsy is '调整收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.tzsyylj is '调整收益月累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.tzsyjlj is '调整收益季累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.tzsynlj is '调整收益年累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.blqtzsy is '补录前调整收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.blqtzsyylj is '补录前调整收益月累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.blqtzsyjlj is '补录前调整收益季累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.blqtzsynlj is '补录前调整收益年累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.blsyje is '补录收益金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.blsyjeylj is '补录收益金额月累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.blsyjejlj is '补录收益金额季累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.blsyjenlj is '补录收益金额年累计';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ljtzysje is '累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.tzhljftpjsy is '调整后累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.ljtzfyje is '累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jjljftpjsy is '计奖累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.dytzysje is '月累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.tzhdyftpjsy is '调整后月累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.dytzfyje is '月累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.jjdyftpjsy is '计奖月累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_tyffzckmx_recal.etl_timestamp is 'ETL处理时间戳';
