/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_yblxdftpmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_yblxdftpmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_yblxdftpmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_yblxdftpmx(
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
grant select on ${iol_schema}.pams_jxbb_yblxdftpmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_yblxdftpmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_yblxdftpmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_yblxdftpmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_yblxdftpmx is '原币类信贷报表整合成结果表';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.jrgjbh is '金融工具编号';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.jydf is '交易对方';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.jyr is '交易日';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.dqr is '到期日';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.bzdm is '币种代码';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.tzje is '投资金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.qmye is '期末余额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.dyrj is '当月日均';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ljrj is '累计日均';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.yqsyl is '预期收益率';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.jxfs is '付息频率';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.tzlx is '投资类型';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ssfhhh is '财务机构';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ssfh is '财务机构名称';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.dylxsr is '当月利息收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.dyftpjsr is '当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ljlxsr is '累计利息收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ljftpjsr is '累计FTP净收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ssjgdh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.khjlxm is '客户经理姓名';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphtzje is '分配后投资金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphqmye is '分配后期末余额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphdyrj is '分配后当月日均';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphljrj is '分配后累计日均';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphdylxsr is '分配后当月利息收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphdyftpzycb is '分配后当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphdyftpjsr is '分配后当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphljlxsr is '分配后累计利息收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphljftpzycb is '分配后累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphljftpjsr is '分配后累计FTP净收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.wjfl is '五级分类';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.yqxyss is '逾期信用损失';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fxjqzcje is '风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ljtzysje is '累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.tzhljftpjsy is '调整后累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.ljtzfyje is '累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.jjljftpjsy is '计奖累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphljtzysje is '分配后累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphtzhljftpjsy is '分配后调整后累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphljtzfyje is '分配后累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphjjljftpjsy is '分配后计奖累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.dytzysje is '月累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.tzhdyftpjsy is '调整后月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.dytzfyje is '月累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.jjdyftpjsy is '计奖月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphdytzysje is '分配后月累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphtzhdyftpjsy is '分配后调整后月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphdytzfyje is '分配后月累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphjjdyftpjsy is '分配后计奖月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphdnmmsy is '分配后当年买卖损益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.fphdngyjzbd is '分配后当年公允价值变动';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx.etl_timestamp is 'ETL处理时间戳';
