/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_lxdftpmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_lxdftpmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_lxdftpmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_lxdftpmx(
    tjrq number(22,0) -- 统计日期
    ,jrgjbh varchar2(75) -- 金融工具编号
    ,khmc varchar2(750) -- 客户名称
    ,khh varchar2(150) -- 客户号
    ,jydf varchar2(150) -- 交易对方
    ,jyr number(22,0) -- 交易日
    ,dqr number(22,0) -- 到期日
    ,bzdm varchar2(15) -- 币种代码
    ,bz varchar2(45) -- 币种
    ,tzje number(25,4) -- 投资金额
    ,qmye number(25,4) -- 期末余额
    ,dyrj number(25,4) -- 当月日均
    ,ljrj number(25,4) -- 累计日均
    ,yqsyl number(25,4) -- 预期收益率
    ,ftpjg number(25,4) -- FTP价格
    ,jxfs varchar2(45) -- 付息频率
    ,tzlx varchar2(45) -- 投资类型
    ,ssfhhh varchar2(45) -- 财务机构
    ,ssfh varchar2(150) -- 财务机构名称
    ,dylxsr number(25,4) -- 当月利息收入
    ,dyftpzycb number(25,4) -- 当月FTP转移成本
    ,dyftpjsr number(25,4) -- 当月FTP净收入
    ,ljlxsr number(25,4) -- 累计利息收入
    ,ljftpzycb number(25,4) -- 累计FTP转移成本
    ,ljftpjsr number(25,4) -- 累计FTP净收入
    ,ssjgdh varchar2(45) -- 所属机构号
    ,ssjgmc varchar2(150) -- 所属机构名称
    ,khjlxm varchar2(150) -- 客户经理姓名
    ,khjlgh varchar2(45) -- 客户经理工号
    ,fpbl number(25,4) -- 分配比例
    ,fphtzje number(25,4) -- 分配后投资金额
    ,fphqmye number(25,4) -- 分配后期末余额
    ,fphdyrj number(25,4) -- 分配后当月日均
    ,fphljrj number(25,4) -- 分配后累计日均
    ,fphdylxsr number(25,4) -- 分配后当月利息收入
    ,fphdyftpzycb number(25,4) -- 分配后当月FTP转移成本
    ,fphdyftpjsr number(25,4) -- 分配后当月FTP净收入
    ,fphljlxsr number(25,4) -- 分配后累计利息收入
    ,fphljftpzycb number(25,4) -- 分配后累计FTP转移成本
    ,fphljftpjsr number(25,4) -- 分配后累计FTP净收入
    ,wjfl varchar2(2) -- 五级分类
    ,yqxyss number(25,4) -- 逾期信用损失
    ,fxjqzcje number(25,4) -- 风险加权资产金额
    ,cpbh varchar2(30) -- 产品编号
    ,xgfxjqzcje number(30,2) -- 新规风险加权资产金额
    ,ljtzysje number(25,4) -- 累计调整营收金额
    ,tzhljftpjsy number(25,4) -- 调整后累计ftp净收益
    ,ljtzfyje number(25,4) -- 累计调整费用金额
    ,jjljftpjsy number(25,4) -- 计奖累计ftp净收益
    ,fphljtzysje number(25,4) -- 分配后累计调整营收金额
    ,fphtzhljftpjsy number(25,4) -- 分配后调整后累计ftp净收益
    ,fphljtzfyje number(25,4) -- 分配后累计调整费用金额
    ,fphjjljftpjsy number(25,4) -- 分配后计奖累计ftp净收益
    ,dytzysje number(25,4) -- 月累计调整营收金额
    ,tzhdyftpjsy number(25,4) -- 调整后月累计FTP净收益
    ,dytzfyje number(25,4) -- 月累计调整费用金额
    ,jjdyftpjsy number(25,4) -- 计奖月累计FTP净收益
    ,fphdytzysje number(25,4) -- 分配后月累计调整营收金额
    ,fphtzhdyftpjsy number(25,4) -- 分配后调整后月累计FTP净收益
    ,fphdytzfyje number(25,4) -- 分配后月累计调整费用金额
    ,fphjjdyftpjsy number(25,4) -- 分配后计奖月累计FTP净收益
    ,fphdnmmsy number(25,4) -- 分配后当年买卖损益
    ,fphdngyjzbd number(25,4) -- 分配后当年公允价值变动
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
grant select on ${iol_schema}.pams_jxbb_lxdftpmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_lxdftpmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_lxdftpmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_lxdftpmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_lxdftpmx is '类信贷ftp明细表';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.jrgjbh is '金融工具编号';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.jydf is '交易对方';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.jyr is '交易日';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.dqr is '到期日';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.bzdm is '币种代码';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.tzje is '投资金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.qmye is '期末余额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.dyrj is '当月日均';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ljrj is '累计日均';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.yqsyl is '预期收益率';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.jxfs is '付息频率';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.tzlx is '投资类型';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ssfhhh is '财务机构';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ssfh is '财务机构名称';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.dylxsr is '当月利息收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.dyftpjsr is '当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ljlxsr is '累计利息收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ljftpjsr is '累计FTP净收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ssjgdh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.khjlxm is '客户经理姓名';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphtzje is '分配后投资金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphqmye is '分配后期末余额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphdyrj is '分配后当月日均';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphljrj is '分配后累计日均';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphdylxsr is '分配后当月利息收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphdyftpzycb is '分配后当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphdyftpjsr is '分配后当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphljlxsr is '分配后累计利息收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphljftpzycb is '分配后累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphljftpjsr is '分配后累计FTP净收入';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.wjfl is '五级分类';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.yqxyss is '逾期信用损失';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fxjqzcje is '风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.xgfxjqzcje is '新规风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ljtzysje is '累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.tzhljftpjsy is '调整后累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.ljtzfyje is '累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.jjljftpjsy is '计奖累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphljtzysje is '分配后累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphtzhljftpjsy is '分配后调整后累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphljtzfyje is '分配后累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphjjljftpjsy is '分配后计奖累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.dytzysje is '月累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.tzhdyftpjsy is '调整后月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.dytzfyje is '月累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.jjdyftpjsy is '计奖月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphdytzysje is '分配后月累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphtzhdyftpjsy is '分配后调整后月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphdytzfyje is '分配后月累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphjjdyftpjsy is '分配后计奖月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphdnmmsy is '分配后当年买卖损益';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.fphdngyjzbd is '分配后当年公允价值变动';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_lxdftpmx.etl_timestamp is 'ETL处理时间戳';
