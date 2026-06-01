/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_yblxdftpmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_yblxdftpmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_yblxdftpmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_yblxdftpmx_recal(
    tjrq number(22) -- 统计日期
    ,jrgjbh varchar2(150) -- 金融工具编号
    ,khmc varchar2(1500) -- 客户名称
    ,khh varchar2(300) -- 客户号
    ,jydf varchar2(300) -- 交易对手分类描述
    ,jyr number(22) -- 交易日期
    ,dqr number(22) -- 到期日期
    ,bzdm varchar2(30) -- 币种代码
    ,bz varchar2(90) -- 币种
    ,tzje number(25,4) -- 交易金额
    ,qmye number(25,4) -- 当期余额
    ,dyrj number(25,4) -- 当月日均
    ,ljrj number(25,4) -- 累计日均
    ,yqsyl number(25,4) -- 票面利率
    ,ftpjg number(25,4) -- FTP价格
    ,jxfs varchar2(90) -- 计息方式
    ,tzlx varchar2(90) -- 资产类型名称
    ,ssfhhh varchar2(90) -- 所属机构编号
    ,ssfh varchar2(300) -- 所属分行
    ,dylxsr number(25,4) -- 当月利息收入
    ,dyftpzycb number(25,4) -- 当月FTP转移成本
    ,dyftpjsr number(25,4) -- 当月FTP季收入
    ,ljlxsr number(25,4) -- 累计利息收入
    ,ljftpzycb number(25,4) -- 累计FTP转移成本
    ,ljftpjsr number(25,4) -- 累计FTP季收入
    ,ssjgdh varchar2(90) -- 所属机构代号
    ,ssjgmc varchar2(300) -- 所属机构名称
    ,khjlxm varchar2(300) -- 客户经理名称
    ,khjlgh varchar2(90) -- 客户经理工号
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
    ,wjfl varchar2(3) -- 五级分类
    ,yqxyss number(25,4) -- 预计信用损失
    ,fxjqzcje number(25,4) -- 风险加权资产金额
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_yblxdftpmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_yblxdftpmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_yblxdftpmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_yblxdftpmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_yblxdftpmx_recal is '原币类信贷报表整合成结果表_重算';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.jrgjbh is '金融工具编号';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.jydf is '交易对手分类描述';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.jyr is '交易日期';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.dqr is '到期日期';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.bzdm is '币种代码';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.tzje is '交易金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.qmye is '当期余额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.dyrj is '当月日均';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ljrj is '累计日均';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.yqsyl is '票面利率';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.jxfs is '计息方式';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.tzlx is '资产类型名称';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ssfhhh is '所属机构编号';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ssfh is '所属分行';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.dylxsr is '当月利息收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.dyftpjsr is '当月FTP季收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ljlxsr is '累计利息收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ljftpjsr is '累计FTP季收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ssjgdh is '所属机构代号';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.khjlxm is '客户经理名称';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphtzje is '分配后投资金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphqmye is '分配后期末余额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphdyrj is '分配后当月日均';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphljrj is '分配后累计日均';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphdylxsr is '分配后当月利息收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphdyftpzycb is '分配后当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphdyftpjsr is '分配后当月FTP净收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphljlxsr is '分配后累计利息收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphljftpzycb is '分配后累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphljftpjsr is '分配后累计FTP净收入';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.wjfl is '五级分类';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.yqxyss is '预计信用损失';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fxjqzcje is '风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ljtzysje is '累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.tzhljftpjsy is '调整后累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.ljtzfyje is '累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.jjljftpjsy is '计奖累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphljtzysje is '分配后累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphtzhljftpjsy is '分配后调整后累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphljtzfyje is '分配后累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphjjljftpjsy is '分配后计奖累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.dytzysje is '月累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.tzhdyftpjsy is '调整后月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.dytzfyje is '月累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.jjdyftpjsy is '计奖月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphdytzysje is '分配后月累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphtzhdyftpjsy is '分配后调整后月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphdytzfyje is '分配后月累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphjjdyftpjsy is '分配后计奖月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphdnmmsy is '分配后当年买卖损益';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.fphdngyjzbd is '分配后当年公允价值变动';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_yblxdftpmx_recal.etl_timestamp is 'ETL处理时间戳';
