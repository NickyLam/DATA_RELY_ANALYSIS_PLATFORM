/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0nwldzqinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0nwldzqinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0nwldzqinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0nwldzqinfo(
    partition_date varchar2(15) -- 批量日期
    ,logical_card_no varchar2(29) -- 逻辑卡号
    ,loan_receipt_nbr varchar2(30) -- 借据号
    ,loan_usage varchar2(15) -- 贷款用途
    ,customer_type varchar2(30) -- 借款人身份
    ,loan_process_flag varchar2(8) -- 借据标识
    ,asset_plan_no varchar2(23) -- 转让计划号
    ,last_bank_group_id varchar2(8) -- 转让前初始银团
    ,ref_nbr varchar2(35) -- 交易参考号
    ,interest_rate varchar2(30) -- 实际执行的年化利率(360天)
    ,lpr varchar2(30) -- 当期lpr值
    ,lpr_date varchar2(30) -- lpr公布日期
    ,reserve5 varchar2(30) -- 备用字段5
    ,reserve6 varchar2(30) -- 备用字段6
    ,reserve7 varchar2(30) -- 备用字段7
    ,reserve8 varchar2(30) -- 备用字段8
    ,reserve9 varchar2(30) -- 备用字段9
    ,reserve10 varchar2(30) -- 备用字段10
    ,reserve11 varchar2(30) -- 备用字段11
    ,reserve12 varchar2(30) -- 备用字段12
    ,reserve13 varchar2(30) -- 备用字段13
    ,reserve14 varchar2(30) -- 备用字段14
    ,reserve15 varchar2(30) -- 备用字段15
    ,reserve16 varchar2(30) -- 备用字段16
    ,reserve17 varchar2(30) -- 备用字段17
    ,reserve18 varchar2(30) -- 备用字段18
    ,reserve19 varchar2(30) -- 备用字段19
    ,reserve20 varchar2(30) -- 备用字段20
    ,reserve21 varchar2(30) -- 备用字段21
    ,reserve22 varchar2(30) -- 备用字段22
    ,reserve23 varchar2(30) -- 备用字段23
    ,reserve24 varchar2(30) -- 备用字段24
    ,reserve25 varchar2(30) -- 备用字段25
    ,reserve26 varchar2(30) -- 备用字段26
    ,reserve27 varchar2(30) -- 备用字段27
    ,reserve28 varchar2(30) -- 备用字段28
    ,reserve29 varchar2(30) -- 备用字段29
    ,reserve30 varchar2(30) -- 备用字段30
    ,reserve31 varchar2(30) -- 备用字段31
    ,reserve32 varchar2(30) -- 备用字段32
    ,reserve33 varchar2(30) -- 备用字段33
    ,reserve34 varchar2(90) -- 备用字段34
    ,reserve35 varchar2(90) -- 备用字段35
    ,reserve36 varchar2(90) -- 备用字段36
    ,reserve37 varchar2(90) -- 备用字段37
    ,reserve38 varchar2(90) -- 备用字段38
    ,reserve39 varchar2(90) -- 备用字段39
    ,reserve40 varchar2(90) -- 备用字段40
    ,reserve41 varchar2(90) -- 备用字段41
    ,reserve42 varchar2(90) -- 备用字段42
    ,reserve43 varchar2(90) -- 备用字段43
    ,reserve44 varchar2(90) -- 备用字段44
    ,reserve45 varchar2(90) -- 备用字段45
    ,reserve46 varchar2(90) -- 备用字段46
    ,reserve47 varchar2(90) -- 备用字段47
    ,reserve48 varchar2(90) -- 备用字段48
    ,reserve49 varchar2(90) -- 备用字段49
    ,reserve50 varchar2(90) -- 备用字段50
    ,reserve51 varchar2(90) -- 备用字段51
    ,reserve52 varchar2(90) -- 备用字段52
    ,reserve53 varchar2(90) -- 备用字段53
    ,reserve54 varchar2(90) -- 备用字段54
    ,reserve55 varchar2(90) -- 备用字段55
    ,reserve56 varchar2(90) -- 备用字段56
    ,reserve57 varchar2(90) -- 备用字段57
    ,reserve58 varchar2(90) -- 备用字段58
    ,reserve59 varchar2(90) -- 备用字段59
    ,reserve60 varchar2(90) -- 备用字段60
    ,reserve61 varchar2(90) -- 备用字段61
    ,reserve62 varchar2(90) -- 备用字段62
    ,reserve63 varchar2(90) -- 备用字段63
    ,reserve64 varchar2(90) -- 备用字段64
    ,reserve65 varchar2(90) -- 备用字段65
    ,reserve66 varchar2(90) -- 备用字段66
    ,reserve67 varchar2(90) -- 备用字段67
    ,reserve68 varchar2(90) -- 备用字段68
    ,reserve69 varchar2(90) -- 备用字段69
    ,reserve70 varchar2(90) -- 备用字段70
    ,reserve71 varchar2(90) -- 备用字段71
    ,reserve72 varchar2(90) -- 备用字段72
    ,reserve73 varchar2(90) -- 备用字段73
    ,reserve74 varchar2(90) -- 备用字段74
    ,reserve75 varchar2(90) -- 备用字段75
    ,reserve76 varchar2(90) -- 备用字段76
    ,reserve77 varchar2(90) -- 备用字段77
    ,reserve78 varchar2(90) -- 备用字段78
    ,reserve79 varchar2(90) -- 备用字段79
    ,reserve80 varchar2(90) -- 备用字段80
    ,reserve81 varchar2(90) -- 备用字段81
    ,reserve82 varchar2(90) -- 备用字段82
    ,reserve83 varchar2(90) -- 备用字段83
    ,reserve84 varchar2(90) -- 备用字段84
    ,reserve85 varchar2(90) -- 备用字段85
    ,reserve86 varchar2(90) -- 备用字段86
    ,reserve87 varchar2(90) -- 备用字段87
    ,reserve88 varchar2(90) -- 备用字段88
    ,reserve89 varchar2(90) -- 备用字段89
    ,reserve90 varchar2(90) -- 备用字段90
    ,reserve91 varchar2(90) -- 备用字段91
    ,reserve92 varchar2(90) -- 备用字段92
    ,reserve93 varchar2(90) -- 备用字段93
    ,reserve94 varchar2(90) -- 备用字段94
    ,reserve95 varchar2(90) -- 备用字段95
    ,reserve96 varchar2(90) -- 备用字段96
    ,reserve97 varchar2(90) -- 备用字段97
    ,reserve98 varchar2(90) -- 备用字段98
    ,reserve99 varchar2(90) -- 备用字段99
    ,reserve100 varchar2(90) -- 备用字段100
    ,reserve101 varchar2(90) -- 备用字段101
    ,reserve102 varchar2(90) -- 备用字段102
    ,reserve103 varchar2(90) -- 备用字段103
    ,reserve104 varchar2(90) -- 备用字段104
    ,reserve105 varchar2(90) -- 备用字段105
    ,reserve106 varchar2(90) -- 备用字段106
    ,reserve107 varchar2(90) -- 备用字段107
    ,reserve108 varchar2(90) -- 备用字段108
    ,reserve109 varchar2(90) -- 备用字段109
    ,reserve110 varchar2(90) -- 备用字段110
    ,reserve111 varchar2(90) -- 备用字段111
    ,reserve112 varchar2(90) -- 备用字段112
    ,reserve113 varchar2(90) -- 备用字段113
    ,reserve114 varchar2(90) -- 备用字段114
    ,reserve115 varchar2(90) -- 备用字段115
    ,reserve116 varchar2(90) -- 备用字段116
    ,reserve117 varchar2(90) -- 备用字段117
    ,reserve118 varchar2(90) -- 备用字段118
    ,reserve119 varchar2(90) -- 备用字段119
    ,reserve120 varchar2(90) -- 备用字段120
    ,reserve121 varchar2(90) -- 备用字段121
    ,reserve122 varchar2(90) -- 备用字段122
    ,reserve123 varchar2(90) -- 备用字段123
    ,reserve124 varchar2(90) -- 备用字段124
    ,reserve125 varchar2(90) -- 备用字段125
    ,reserve126 varchar2(90) -- 备用字段126
    ,reserve127 varchar2(90) -- 备用字段127
    ,reserve128 varchar2(90) -- 备用字段128
    ,reserve129 varchar2(90) -- 备用字段129
    ,reserve130 varchar2(90) -- 备用字段130
    ,reserve131 varchar2(90) -- 备用字段131
    ,reserve132 varchar2(90) -- 备用字段132
    ,reserve133 varchar2(90) -- 备用字段133
    ,reserve134 varchar2(90) -- 备用字段134
    ,reserve135 varchar2(90) -- 备用字段135
    ,reserve136 varchar2(90) -- 备用字段136
    ,reserve137 varchar2(90) -- 备用字段137
    ,reserve138 varchar2(90) -- 备用字段138
    ,reserve139 varchar2(90) -- 备用字段139
    ,reserve140 varchar2(90) -- 备用字段140
    ,reserve141 varchar2(90) -- 备用字段141
    ,reserve142 varchar2(90) -- 备用字段142
    ,reserve143 varchar2(90) -- 备用字段143
    ,reserve144 varchar2(90) -- 备用字段144
    ,reserve145 varchar2(90) -- 备用字段145
    ,reserve146 varchar2(90) -- 备用字段146
    ,reserve147 varchar2(90) -- 备用字段147
    ,reserve148 varchar2(90) -- 备用字段148
    ,reserve149 varchar2(90) -- 备用字段149
    ,reserve150 varchar2(90) -- 备用字段150
    ,batchfilename varchar2(192) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
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
grant select on ${iol_schema}.mpcs_a0nwldzqinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0nwldzqinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0nwldzqinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0nwldzqinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0nwldzqinfo is '微粒贷借据补充信息表';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.partition_date is '批量日期';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.logical_card_no is '逻辑卡号';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.loan_receipt_nbr is '借据号';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.loan_usage is '贷款用途';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.customer_type is '借款人身份';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.loan_process_flag is '借据标识';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.asset_plan_no is '转让计划号';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.last_bank_group_id is '转让前初始银团';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.ref_nbr is '交易参考号';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.interest_rate is '实际执行的年化利率(360天)';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.lpr is '当期lpr值';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.lpr_date is 'lpr公布日期';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve5 is '备用字段5';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve6 is '备用字段6';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve7 is '备用字段7';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve8 is '备用字段8';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve9 is '备用字段9';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve10 is '备用字段10';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve11 is '备用字段11';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve12 is '备用字段12';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve13 is '备用字段13';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve14 is '备用字段14';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve15 is '备用字段15';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve16 is '备用字段16';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve17 is '备用字段17';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve18 is '备用字段18';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve19 is '备用字段19';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve20 is '备用字段20';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve21 is '备用字段21';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve22 is '备用字段22';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve23 is '备用字段23';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve24 is '备用字段24';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve25 is '备用字段25';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve26 is '备用字段26';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve27 is '备用字段27';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve28 is '备用字段28';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve29 is '备用字段29';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve30 is '备用字段30';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve31 is '备用字段31';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve32 is '备用字段32';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve33 is '备用字段33';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve34 is '备用字段34';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve35 is '备用字段35';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve36 is '备用字段36';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve37 is '备用字段37';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve38 is '备用字段38';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve39 is '备用字段39';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve40 is '备用字段40';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve41 is '备用字段41';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve42 is '备用字段42';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve43 is '备用字段43';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve44 is '备用字段44';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve45 is '备用字段45';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve46 is '备用字段46';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve47 is '备用字段47';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve48 is '备用字段48';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve49 is '备用字段49';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve50 is '备用字段50';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve51 is '备用字段51';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve52 is '备用字段52';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve53 is '备用字段53';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve54 is '备用字段54';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve55 is '备用字段55';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve56 is '备用字段56';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve57 is '备用字段57';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve58 is '备用字段58';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve59 is '备用字段59';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve60 is '备用字段60';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve61 is '备用字段61';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve62 is '备用字段62';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve63 is '备用字段63';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve64 is '备用字段64';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve65 is '备用字段65';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve66 is '备用字段66';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve67 is '备用字段67';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve68 is '备用字段68';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve69 is '备用字段69';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve70 is '备用字段70';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve71 is '备用字段71';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve72 is '备用字段72';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve73 is '备用字段73';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve74 is '备用字段74';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve75 is '备用字段75';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve76 is '备用字段76';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve77 is '备用字段77';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve78 is '备用字段78';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve79 is '备用字段79';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve80 is '备用字段80';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve81 is '备用字段81';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve82 is '备用字段82';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve83 is '备用字段83';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve84 is '备用字段84';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve85 is '备用字段85';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve86 is '备用字段86';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve87 is '备用字段87';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve88 is '备用字段88';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve89 is '备用字段89';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve90 is '备用字段90';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve91 is '备用字段91';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve92 is '备用字段92';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve93 is '备用字段93';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve94 is '备用字段94';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve95 is '备用字段95';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve96 is '备用字段96';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve97 is '备用字段97';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve98 is '备用字段98';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve99 is '备用字段99';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve100 is '备用字段100';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve101 is '备用字段101';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve102 is '备用字段102';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve103 is '备用字段103';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve104 is '备用字段104';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve105 is '备用字段105';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve106 is '备用字段106';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve107 is '备用字段107';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve108 is '备用字段108';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve109 is '备用字段109';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve110 is '备用字段110';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve111 is '备用字段111';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve112 is '备用字段112';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve113 is '备用字段113';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve114 is '备用字段114';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve115 is '备用字段115';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve116 is '备用字段116';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve117 is '备用字段117';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve118 is '备用字段118';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve119 is '备用字段119';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve120 is '备用字段120';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve121 is '备用字段121';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve122 is '备用字段122';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve123 is '备用字段123';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve124 is '备用字段124';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve125 is '备用字段125';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve126 is '备用字段126';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve127 is '备用字段127';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve128 is '备用字段128';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve129 is '备用字段129';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve130 is '备用字段130';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve131 is '备用字段131';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve132 is '备用字段132';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve133 is '备用字段133';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve134 is '备用字段134';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve135 is '备用字段135';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve136 is '备用字段136';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve137 is '备用字段137';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve138 is '备用字段138';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve139 is '备用字段139';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve140 is '备用字段140';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve141 is '备用字段141';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve142 is '备用字段142';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve143 is '备用字段143';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve144 is '备用字段144';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve145 is '备用字段145';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve146 is '备用字段146';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve147 is '备用字段147';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve148 is '备用字段148';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve149 is '备用字段149';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.reserve150 is '备用字段150';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a0nwldzqinfo.etl_timestamp is 'ETL处理时间戳';
