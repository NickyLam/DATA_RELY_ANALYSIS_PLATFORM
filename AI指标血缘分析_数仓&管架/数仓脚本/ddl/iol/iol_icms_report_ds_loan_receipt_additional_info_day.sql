/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_report_ds_loan_receipt_additional_info_day
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day
whenever sqlerror continue none;
drop table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day(
    partitiondate varchar2(10) -- 批量日期
    ,logicalcardno varchar2(19) -- 逻辑卡号
    ,loanreceiptnbr varchar2(20) -- 借据号
    ,loanusage varchar2(20) -- 贷款用途
    ,customertype varchar2(40) -- 借款人身份
    ,loanprocessflag varchar2(10) -- 借据标识
    ,assetplanno varchar2(15) -- 资产计划号
    ,lastbankgroupid varchar2(5) -- 初始参贷方案
    ,refnbr varchar2(23) -- 交易参考号
    ,integererestrate number(12,6) -- 实际执行的年化利率（360天）
    ,lpr number(12,6) -- 当期lpr值
    ,lprdate date -- lpr公布日期
    ,reserve1 varchar2(20) -- 备用字段1
    ,reserve2 varchar2(20) -- 备用字段2
    ,reserve3 varchar2(20) -- 备用字段3
    ,reserve4 varchar2(20) -- 备用字段4
    ,reserve5 varchar2(40) -- 备用字段5
    ,reserve6 varchar2(40) -- 备用字段6
    ,reserve7 varchar2(40) -- 备用字段7
    ,loantype varchar2(40) -- 还款方式
    ,reserve9 varchar2(40) -- 被操作交易参考号
    ,reserve10 varchar2(40) -- 操作时间
    ,identifytype varchar2(40) -- 客户身份
    ,remainprinamtob varchar2(20) -- 归属于合作机构的本金余额
    ,reserve13 varchar2(20) -- 备用字段13
    ,reserve14 varchar2(20) -- 客户收款银行名称（仅有收款行为出资行时有值）
    ,reserve15 varchar2(20) -- 客户收款银行行号（仅有收款行为出资行时有值）
    ,reserve16 varchar2(20) -- 客户收款账号（仅有收款行为出资行时有值）
    ,reserve17 varchar2(40) -- 借款用途
    ,reserve18 varchar2(40) -- 客户号
    ,reserve19 varchar2(20) -- 借款合同名称
    ,reserve20 varchar2(20) -- 借据起始日期
    ,reserve21 varchar2(40) -- 借据原始到期日
    ,reserve22 varchar2(20) -- 借据结清日期
    ,reserve23 varchar2(40) -- 备用字段23
    ,reserve24 varchar2(20) -- 备用字段24
    ,reserve25 varchar2(20) -- 备用字段25
    ,reserve26 varchar2(20) -- 备用字段26
    ,reserve27 varchar2(40) -- 备用字段27
    ,reserve28 varchar2(40) -- 备用字段28
    ,reserve29 varchar2(40) -- 备用字段29
    ,reserve30 varchar2(120) -- 备用字段30
    ,reserve31 varchar2(120) -- 备用字段31
    ,reserve32 varchar2(120) -- 备用字段32
    ,reserve33 varchar2(120) -- 备用字段33
    ,reserve34 varchar2(120) -- 备用字段34
    ,reserve35 varchar2(120) -- 备用字段35
    ,reserve36 varchar2(120) -- 备用字段36
    ,reserve37 varchar2(120) -- 备用字段37
    ,reserve38 varchar2(120) -- 备用字段38
    ,reserve39 varchar2(120) -- 备用字段39
    ,reserve40 varchar2(120) -- 备用字段40
    ,reserve41 varchar2(120) -- 备用字段41
    ,reserve42 varchar2(120) -- 备用字段42
    ,reserve43 varchar2(120) -- 备用字段43
    ,reserve44 varchar2(120) -- 备用字段44
    ,reserve45 varchar2(120) -- 备用字段45
    ,reserve46 varchar2(120) -- 备用字段46
    ,reserve47 varchar2(120) -- 备用字段47
    ,reserve48 varchar2(120) -- 备用字段48
    ,reserve49 varchar2(120) -- 备用字段49
    ,reserve50 varchar2(120) -- 备用字段50
    ,reserve51 varchar2(120) -- 备用字段51
    ,reserve52 varchar2(120) -- 备用字段52
    ,reserve53 varchar2(120) -- 备用字段53
    ,reserve54 varchar2(120) -- 备用字段54
    ,reserve55 varchar2(120) -- 备用字段55
    ,reserve56 varchar2(120) -- 备用字段56
    ,reserve57 varchar2(120) -- 备用字段57
    ,reserve58 varchar2(120) -- 备用字段58
    ,reserve59 varchar2(120) -- 备用字段59
    ,reserve60 varchar2(120) -- 备用字段60
    ,reserve61 varchar2(120) -- 备用字段61
    ,reserve62 varchar2(120) -- 备用字段62
    ,reserve63 varchar2(120) -- 备用字段63
    ,reserve64 varchar2(120) -- 备用字段64
    ,reserve65 varchar2(120) -- 备用字段65
    ,reserve66 varchar2(120) -- 备用字段66
    ,reserve67 varchar2(120) -- 备用字段67
    ,reserve68 varchar2(120) -- 备用字段68
    ,reserve69 varchar2(120) -- 备用字段69
    ,reserve70 varchar2(120) -- 备用字段70
    ,reserve71 varchar2(120) -- 备用字段71
    ,reserve72 varchar2(120) -- 备用字段72
    ,reserve73 varchar2(120) -- 备用字段73
    ,reserve74 varchar2(120) -- 备用字段74
    ,reserve75 varchar2(120) -- 备用字段75
    ,reserve76 varchar2(120) -- 备用字段76
    ,reserve77 varchar2(120) -- 备用字段77
    ,reserve78 varchar2(120) -- 备用字段78
    ,reserve79 varchar2(120) -- 备用字段79
    ,reserve80 varchar2(120) -- 备用字段80
    ,reserve81 varchar2(120) -- 备用字段81
    ,reserve82 varchar2(120) -- 备用字段82
    ,reserve83 varchar2(120) -- 备用字段83
    ,reserve84 varchar2(120) -- 备用字段84
    ,reserve85 varchar2(120) -- 备用字段85
    ,reserve86 varchar2(120) -- 备用字段86
    ,reserve87 varchar2(120) -- 备用字段87
    ,reserve88 varchar2(120) -- 备用字段88
    ,reserve89 varchar2(120) -- 备用字段89
    ,reserve90 varchar2(120) -- 备用字段90
    ,reserve91 varchar2(120) -- 备用字段91
    ,reserve92 varchar2(120) -- 备用字段92
    ,reserve93 varchar2(120) -- 备用字段93
    ,reserve94 varchar2(120) -- 备用字段94
    ,reserve95 varchar2(120) -- 备用字段95
    ,reserve96 varchar2(120) -- 备用字段96
    ,reserve97 varchar2(120) -- 备用字段97
    ,reserve98 varchar2(120) -- 备用字段98
    ,reserve99 varchar2(120) -- 备用字段99
    ,reserve100 varchar2(120) -- 备用字段100
    ,reserve101 varchar2(120) -- 备用字段101
    ,reserve102 varchar2(120) -- 备用字段102
    ,reserve103 varchar2(120) -- 备用字段103
    ,reserve104 varchar2(120) -- 备用字段104
    ,reserve105 varchar2(120) -- 备用字段105
    ,reserve106 varchar2(120) -- 备用字段106
    ,reserve107 varchar2(120) -- 备用字段107
    ,reserve108 varchar2(120) -- 备用字段108
    ,reserve109 varchar2(120) -- 备用字段109
    ,reserve110 varchar2(120) -- 备用字段110
    ,reserve111 varchar2(120) -- 备用字段111
    ,reserve112 varchar2(120) -- 备用字段112
    ,reserve113 varchar2(120) -- 备用字段113
    ,reserve114 varchar2(120) -- 备用字段114
    ,reserve115 varchar2(120) -- 备用字段115
    ,reserve116 varchar2(120) -- 备用字段116
    ,reserve117 varchar2(120) -- 备用字段117
    ,reserve118 varchar2(120) -- 备用字段118
    ,reserve119 varchar2(120) -- 备用字段119
    ,reserve120 varchar2(120) -- 备用字段120
    ,reserve121 varchar2(120) -- 备用字段121
    ,reserve122 varchar2(120) -- 备用字段122
    ,reserve123 varchar2(120) -- 备用字段123
    ,reserve124 varchar2(120) -- 备用字段124
    ,reserve125 varchar2(120) -- 备用字段125
    ,reserve126 varchar2(120) -- 备用字段126
    ,reserve127 varchar2(120) -- 备用字段127
    ,reserve128 varchar2(120) -- 备用字段128
    ,reserve129 varchar2(120) -- 备用字段129
    ,reserve130 varchar2(120) -- 备用字段130
    ,reserve131 varchar2(120) -- 备用字段131
    ,reserve132 varchar2(120) -- 备用字段132
    ,reserve133 varchar2(120) -- 备用字段133
    ,reserve134 varchar2(120) -- 备用字段134
    ,reserve135 varchar2(120) -- 备用字段135
    ,reserve136 varchar2(120) -- 备用字段136
    ,reserve137 varchar2(120) -- 备用字段137
    ,reserve138 varchar2(120) -- 备用字段138
    ,reserve139 varchar2(120) -- 备用字段139
    ,reserve140 varchar2(120) -- 备用字段140
    ,reserve141 varchar2(120) -- 备用字段141
    ,reserve142 varchar2(120) -- 备用字段142
    ,reserve143 varchar2(120) -- 备用字段143
    ,reserve144 varchar2(120) -- 备用字段144
    ,reserve145 varchar2(120) -- 备用字段145
    ,reserve146 varchar2(120) -- 备用字段146
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
grant select on ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day to ${iml_schema};
grant select on ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day to ${icl_schema};
grant select on ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day to ${idl_schema};
grant select on ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day is '微粒贷借据补充信息表';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.partitiondate is '批量日期';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.logicalcardno is '逻辑卡号';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.loanreceiptnbr is '借据号';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.loanusage is '贷款用途';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.customertype is '借款人身份';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.loanprocessflag is '借据标识';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.assetplanno is '资产计划号';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.lastbankgroupid is '初始参贷方案';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.refnbr is '交易参考号';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.integererestrate is '实际执行的年化利率（360天）';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.lpr is '当期lpr值';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.lprdate is 'lpr公布日期';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve1 is '备用字段1';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve2 is '备用字段2';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve3 is '备用字段3';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve4 is '备用字段4';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve5 is '备用字段5';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve6 is '备用字段6';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve7 is '备用字段7';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.loantype is '还款方式';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve9 is '被操作交易参考号';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve10 is '操作时间';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.identifytype is '客户身份';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.remainprinamtob is '归属于合作机构的本金余额';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve13 is '备用字段13';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve14 is '客户收款银行名称（仅有收款行为出资行时有值）';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve15 is '客户收款银行行号（仅有收款行为出资行时有值）';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve16 is '客户收款账号（仅有收款行为出资行时有值）';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve17 is '借款用途';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve18 is '客户号';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve19 is '借款合同名称';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve20 is '借据起始日期';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve21 is '借据原始到期日';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve22 is '借据结清日期';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve23 is '备用字段23';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve24 is '备用字段24';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve25 is '备用字段25';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve26 is '备用字段26';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve27 is '备用字段27';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve28 is '备用字段28';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve29 is '备用字段29';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve30 is '备用字段30';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve31 is '备用字段31';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve32 is '备用字段32';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve33 is '备用字段33';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve34 is '备用字段34';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve35 is '备用字段35';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve36 is '备用字段36';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve37 is '备用字段37';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve38 is '备用字段38';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve39 is '备用字段39';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve40 is '备用字段40';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve41 is '备用字段41';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve42 is '备用字段42';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve43 is '备用字段43';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve44 is '备用字段44';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve45 is '备用字段45';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve46 is '备用字段46';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve47 is '备用字段47';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve48 is '备用字段48';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve49 is '备用字段49';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve50 is '备用字段50';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve51 is '备用字段51';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve52 is '备用字段52';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve53 is '备用字段53';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve54 is '备用字段54';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve55 is '备用字段55';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve56 is '备用字段56';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve57 is '备用字段57';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve58 is '备用字段58';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve59 is '备用字段59';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve60 is '备用字段60';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve61 is '备用字段61';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve62 is '备用字段62';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve63 is '备用字段63';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve64 is '备用字段64';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve65 is '备用字段65';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve66 is '备用字段66';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve67 is '备用字段67';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve68 is '备用字段68';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve69 is '备用字段69';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve70 is '备用字段70';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve71 is '备用字段71';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve72 is '备用字段72';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve73 is '备用字段73';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve74 is '备用字段74';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve75 is '备用字段75';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve76 is '备用字段76';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve77 is '备用字段77';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve78 is '备用字段78';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve79 is '备用字段79';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve80 is '备用字段80';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve81 is '备用字段81';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve82 is '备用字段82';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve83 is '备用字段83';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve84 is '备用字段84';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve85 is '备用字段85';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve86 is '备用字段86';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve87 is '备用字段87';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve88 is '备用字段88';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve89 is '备用字段89';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve90 is '备用字段90';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve91 is '备用字段91';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve92 is '备用字段92';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve93 is '备用字段93';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve94 is '备用字段94';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve95 is '备用字段95';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve96 is '备用字段96';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve97 is '备用字段97';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve98 is '备用字段98';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve99 is '备用字段99';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve100 is '备用字段100';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve101 is '备用字段101';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve102 is '备用字段102';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve103 is '备用字段103';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve104 is '备用字段104';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve105 is '备用字段105';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve106 is '备用字段106';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve107 is '备用字段107';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve108 is '备用字段108';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve109 is '备用字段109';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve110 is '备用字段110';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve111 is '备用字段111';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve112 is '备用字段112';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve113 is '备用字段113';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve114 is '备用字段114';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve115 is '备用字段115';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve116 is '备用字段116';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve117 is '备用字段117';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve118 is '备用字段118';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve119 is '备用字段119';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve120 is '备用字段120';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve121 is '备用字段121';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve122 is '备用字段122';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve123 is '备用字段123';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve124 is '备用字段124';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve125 is '备用字段125';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve126 is '备用字段126';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve127 is '备用字段127';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve128 is '备用字段128';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve129 is '备用字段129';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve130 is '备用字段130';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve131 is '备用字段131';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve132 is '备用字段132';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve133 is '备用字段133';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve134 is '备用字段134';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve135 is '备用字段135';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve136 is '备用字段136';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve137 is '备用字段137';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve138 is '备用字段138';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve139 is '备用字段139';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve140 is '备用字段140';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve141 is '备用字段141';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve142 is '备用字段142';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve143 is '备用字段143';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve144 is '备用字段144';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve145 is '备用字段145';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.reserve146 is '备用字段146';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.start_dt is '开始时间';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.end_dt is '结束时间';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.id_mark is '增删标志';
comment on column ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day.etl_timestamp is 'ETL处理时间戳';
